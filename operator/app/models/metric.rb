class Metric
  FAMILY = [:Metric, :MetricRollup1, :MetricRollup12, :MetricRollup24]
  DB = Cassandra.new("Monit", CASSANDRA_CONFIG["default"]["servers"])

  def initialize(service)
    @service = service
    @uuid = @service.uuid
    @interval = @service.check_interval
    @allow_distance = @interval * 1.2
    @history_cache = {}
  end

  def default_view
    View.first(:conditions => {:visible_type => "service_default", :visible_id => @service.type_id, :enable => 1}, :include => ['items'])
  end

  def views
    View.all(:conditions => {:visible_type => "service_current", :visible_id => @service.type_id, :enable => 1}, :include => ['items'])
  end

  def history_views
    View.all(:conditions => {:visible_type => "service_history", :visible_id => @service.type_id, :enable => 1}, :include => ['items'])
  end

  def history options
    start = options[:start].to_i
    finish = options[:finish].to_i
    key = "C#{start}_#{finish}"
    return @history_cache[key] if @history_cache.has_key?(key)

    config = self.class.config(options[:start], options[:finish], @interval)
    data = DB.get(config[:family], @uuid, :start => start.to_s, :finish => finish.to_s, :count => 1000)
    set_history data, start, finish, config[:interval]
  end

  def set_history data, start, finish, interval
    start = start.to_i
    finish = finish.to_i
    key = "C#{start}_#{finish}"
    @history_interval = interval
    @history_allow_distance = @history_interval * 1.2
    @history_cache[key] = complete(data, start, finish)
  end

  def current=(data)
    set_current(data)
  end

  def current
    return @current if @has_current
    set_current(DB.get(:Metric, @uuid, :count => 1, :reversed => true))
  end

  #  def last
  #    data = DB.get(:Metric, @uuid, :count => 1, :reversed => true)
  #    data = data.to_a.first
  #    data && data[1]
  #  end

  private

  #允许值与当前时间的间隔大于检测频度20%
  def set_current data
    @has_current = true
    data = data.to_a.first
    if data and data[1]
      time_distance = Time.now.to_i - data[0].to_i
      @current = time_distance < @allow_distance ? data[1] : nil
      #@current = data[1] #For test
    else
      @current = nil
    end
    @current 
  end

  def complete db, start, finish
    cl = db.class
    db = db.to_a
    data = cl.new
    if db.size > 0
      point(start, db.first[0].to_i, data)
      db.each do |d|
        data[d[0]] = d[1]
      end
      point(db.last[0].to_i, finish, data)
    end
    data
    data_array = []
    data.each do |k, v|
      v["parent_key"] = k
      data_array << v
    end
    data_array
  end

  def point start, finish, data
    if finish - start > @history_allow_distance
      start = start + @history_interval
      data[start.to_s] = {}
      point start, finish, data
    end
  end

  class << self
    def history services, options
      db = DB.multi_get(:Metric, services.collect{|s| s.uuid }, :start => options[:start].to_i.to_s, :finish => options[:finish].to_i.to_s, :count => 1000)
      db
    end

    def current services
      data = DB.multi_get(:Metric, services.collect{|s| s.uuid }, :count => 1, :reversed => true)
      services.collect do |service|
        metric = service.metric
        metric.current = data[service.uuid]
        metric
      end
    end

    def config start, finish, interval, mini = false
      #起始时间在5天内，间隔小于等于2天，直接从原始数据读取    
      #起始时间在5天内，间隔大于2天，从1小时归并读取   
      #起始时间在最近30天内，任意间隔，从1小时归并读取   
      #起始时间在最近1年内，任意间距，从12小时归并读取   
      #起始时间在最近2年内，任意间距，从24小时归并读取   
      now = Time.now
      far = now - start
      distance = finish - start
      family = nil
      if(far <= 5.days)
        if distance <= 2.days
          family = FAMILY[0]
        else
          family = FAMILY[1]
          interval = 1.hour.to_i
        end
      elsif( far <= 30.days)
        family = FAMILY[1]
        interval = 1.hour.to_i
      elsif( far <= 1.year)
        family = FAMILY[2]
        interval = 12.hours.to_i
      else
        family = FAMILY[3]
        interval = 24.hours.to_i
      end
      {:interval => interval, :family => family}
    end
  end
end
