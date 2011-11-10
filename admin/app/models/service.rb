# 一个服务对象可能属于某个主机，也可能属于某个应用，
# 1：表示该服务对象属于某个主机
# 2：表示该服务对象属于某个应用
require "pn_generator"
class Service < ActiveRecord::Base
  @@threshold_condition = [["大于", ">"], ["大于等于", ">="], ["小于", "<"], ["小于等于", "<="], ["等于", "="]]
  @@threshold_operate = [["或者", "|"], ["并且", "&"]]
  @@serviceable_types = [{:id => 1, :name => "host", :title => "主机"}, {:id => 2, :name => "app", :title => "应用"}, {:id => 3, :name => "site", :title => "网站"}, {:id => 4, :name => "device", :title => "网络"}]
  @@serviceable_names = @@serviceable_types.collect{ |x| x[:name] }
  cattr_reader :serviceable_types, :serviceable_names, :threshold_operate, :threshold_condition
  attr :metric

  @@serviceable_types.each do |s|
    belongs_to s[:name].to_sym, :foreign_key => 'serviceable_id'
  end

  belongs_to :type, :foreign_key => 'type_id', :class_name => 'ServiceType'
  has_many :alerts, :foreign_key => 'service_id', :dependent => :destroy
  has_many :alert_notifications,  :foreign_key => 'service_id', :dependent => :destroy

  has_one :default_view, :class_name => 'View', :primary_key => 'type_id', :foreign_key => 'visible_id', :conditions => {:visible_type => "service_default", :enable => 1}, :include => ['items']
  has_many :views, :class_name => 'View', :primary_key => 'type_id', :foreign_key => 'visible_id', :conditions => {:visible_type => "service_current", :enable => 1}, :include => ['items']
  has_many :history_views, :class_name => 'View', :primary_key => 'type_id', :foreign_key => 'visible_id', :conditions => {:visible_type => "service_history", :enable => 1}, :include => ['items']



  validates_presence_of :name
  validates_presence_of :serviceable_id
  validates_presence_of :type_id
  validates_inclusion_of :check_interval, :in => [300, 600, 1800, 3600]
  validates_format_of       :name,     :with => /\A[^[:cntrl:]\\<>&]*\z/,  :message => "不能含有\\/<>&", :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  #validates_uniqueness_of :name
  validates_uniqueness_of   :params, :scope => [:serviceable_id, :command, :tenant_id]

  validates_each :params do |record, attr, value|
    error = false
    record.type.params.each do |param|
      param.validate
      error = true if param.error
    end
    record.errors.add attr, "未通过验证" if error
  end
  
  def metric
    @metric ||= Metric.new(self)
  end

  def status1
    @status1 ||=Status1.new(self)
  end

  
  def is_ctrl?
    ctrl_state == 1
  end

  def threshold_warning_text
    read_attribute :threshold_warning
  end

  def threshold_critical_text
    read_attribute :threshold_critical
  end

  def threshold_warning
    @cache_threshold_warning || parse_threshold_warning
  end

  def threshold_critical
    @cache_threshold_critical || parse_threshold_critical
  end

  def threshold_warning=(val)
    s = PNGenerator.new(val)
    str = nil
    str = s.to_s
    write_attribute :threshold_warning, str
  end

  def threshold_critical=(val)
    s = PNGenerator.new(val)
    str = nil
    str = s.to_s
    write_attribute :threshold_critical, str
  end

  def params
    #Gen params_object
    params_object
    read_attribute :params
  end

  def params_object
    @cache_params || parse_params
  end

  def params=(val)
    if val.is_a? Hash
      ar = params_object
      type.params.each do |param|
        if param.param_type == 1
          name = param.name.to_sym
          if val.has_key?(name)
            v = val[name]
          else
            v = param.default_value
          end
        elsif param.param_type == 2
          v = param.default_value
        end
        ar[param.name.to_sym] = v
        param.value = v
      end
      @cache_params = ar
      write_attribute :params, Rack::Utils.unescape(ar.collect{|x| x.join("=")}.join("&"))
    else
      write_attribute :params, val
    end
  end

  def before_validation
    #set default params
    send("params=", {}) if params.blank?
    [:command, :external, :serviceable_type].each do |attr|
      self[attr] = self.type[attr]
    end
  end


  def before_create
    uuid = Service.find_by_sql("select uuid() uid from dual")[0].uid
    send("uuid=",uuid)
  end

  def serviceable_name
    @serviceable_name || (@serviceable_name = @@serviceable_types.select{ |x| x[:id] == serviceable_type}.first[:name])
  end

  def serviceable
    send(serviceable_name)
  end

  def status_name
    status && self.class.status[status] ? self.class.status[status] : 'pending'
  end

  def human_status_name
    I18n.t("status.service.#{status_name}")
  end

  private

  def parse_params
    @cache_params = ActiveSupport::OrderedHash.new
    old = Rack::Utils.parse_query(params)#.symbolize_keys
    type.params.each do |param|
      v = nil
      if old.has_key?(param.name)
        v = old[param.name]
      else
        v = param.default_value
      end
      param.value = v
      @cache_params[param.name.to_sym] = v
    end
    @cache_params
  end

  def parse_threshold_critical
    val = read_attribute(:threshold_critical)
    val ||= type.threshold_critical
    @cache_threshold_critical = PNGenerator.new val
  end

  def parse_threshold_warning
    val = read_attribute(:threshold_warning)
    val ||= type.threshold_warning
    @cache_threshold_warning = PNGenerator.new val
  end

  class << self
    @@status = ['ok', 'warning', 'critical', 'unknown', 'pending']
    def status
      @@status 
    end

    def status_colors
      ["33FF00", "CCFF33", "F83838", "FF9900", "ACACAC"]
    end

    def gen attrs
      service = self.new(attrs)
      type = service.type
      [:check_interval, :threshold_critical, :threshold_warning].each do |attr|
        service[attr] = type[attr]
      end
      service[:name] = type[:default_name]
      service
    end

    # 返回当前系统中应用的健康性
    def heath tenant_id
      heath_row = find :first, :select => "count(case status when 0 then 1 else null end) as healthy, count(*) as host_count", :conditions => {:tenant_id => tenant_id}
      return 0 if heath_row.host_count.to_i == 0
      ((heath_row.healthy.to_f / heath_row.host_count.to_f) * 100).reserve2
    end
  end
end
