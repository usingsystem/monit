class Status
  @@family = [:Status, :StatusRollup1, :StatusRollup12, :StatusRollup24]
  def initialize(service)
    @service = service
    @uuid = @service.uuid
    @db = Cassandra.new("Monit", CASSANDRA_CONFIG["default"]["servers"])
  end


  def history options
    finish = options[:finish].to_i
    start = options[:start].to_i
    db = @db.get(@@family[0], @uuid, :start => start.to_s, :finish => finish.to_s)
    status = {"ok" => 0, "warning" => 0, "unknown" => 0, "critical" => 0}
    db.each do |key, val|
      status.each do |k, v|
        status[k] = val[k].to_i + status[k]
      end
    end
    status
  end

  class << self

  def host_view data
    data = tr({"ok" => "up", "warning" => "up", "unknown" => "down", "critical" => "down"}, data)
    view = View.new(:name => "状态", :dimensionality => 2, :enable => 1, :template => "status")
    data.each do |k, v|
      view.items << ViewItem.new(:name => k, :color => Host.status_colors[Host.status.index(k)], :alias => I18n.t("status.host.#{k}"), :data_type => "int")
    end
    view.data = data
    view
  end
    def to_host data
      tr({"ok" => "up", "warning" => "up", "unknown" => "down", "critical" => "down"}, data)
    end
    def tr config, data
      new = {}
      config.each do |k, v|
        new[v] ||= 0
        new[v] = new[v] + data[k]
      end
      new
    end
  end
end
