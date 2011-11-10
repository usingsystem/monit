class AvailController < ApplicationController
  menu_item 'reports'
  before_filter :dict
  def index
    redirect_to sites_avail_path and return
  end

  def sites
    @sites = Site.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_index_views(Site, Status.history(@sites, @date_range))
    set_index_respond
  end

  def apps
    @apps = App.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_index_views(App, Status.history(@apps, @date_range))
    set_index_respond
  end

  def hosts
    @hosts = Host.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_index_views(Host, Status.history(@hosts, @date_range))
    set_index_respond
  end

  def devices
    @devices = Device.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_index_views(Device, Status.history(@devices, @date_range))
    set_index_respond
  end

  def services
    get_sources
    if @services
      set_index_views(Service, Status.history(@services, @date_range))
      set_index_respond
    end
  end

  def show
    if @service
      service
    elsif @app
      app
    elsif @site
      site
    elsif @host
      host
    elsif @device
      device
    else
      redirect_to sites_avail_path and return
    end
  end

  def app
    @apps = App.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_views(@app.status_data)
    render :action => 'app'
  end

  def host
    @hosts = Host.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_views(@host.status_data)
    render :action => 'host'
  end

  def device
    @devices = Device.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_views(@device.status_data)
    render :action => 'device'
  end

  def site
    @sites = Site.all :conditions=>{:tenant_id => current_user.tenant_id}
    set_views(@site.status_data)
    render :action => 'site'
  end

  def service
    get_sources
    set_views(@service.status_data)
    render :action => 'service'
  end

  private

  def set_index_views model, status_data
    unless status_data.nil?
      cont = model.name.downcase.pluralize
      options = @date_range.merge(:show_url => "/#{cont}/${id}", :more_url => "/#{cont}/${id}/avail#{params[:date].blank? ? nil : "?date=" + params[:date] }")
      @chart_view = Status.view(model, status_data, options, true)
      @data_view = Status.view(model, status_data, options)
      @chart_view.name = @human_date + @chart_view.name
      @data_view.name = @human_date + @data_view.name
    end
  end

  def set_index_respond
    respond_to do |format|
      format.html # index.html.erb
      format.png{ # index.html.erb
        @chart_view.template = "pltcolumn_stacked"
        @chart_view.height = 300
        @chart_view.width = 600
      }
    end
  end

  def set_views status
    @history_chart_view = status.history_view(@date_range, true)
    @history_view = status.history_view(@date_range)
    @total_chart_view = status.total_view(@date_range, true)
    @history_chart_view.name = @human_date + @history_chart_view.name
    @history_view.name = @human_date + @history_view.name
    @total_chart_view.name = @human_date + @total_chart_view.name
  end

  def get_sources
    @source_types = ["host", "app", "site", "device"]
    if @app
      @source_type = "app"
    elsif @site
      @source_type = "site"
    elsif @host
      @source_type = "host"
    elsif @device
      @source_type = "device"
    else
      @source_type = params[:source_type]
    end
    @source_type = "host" unless @source_types.include?(@source_type)
    @sources = case @source_type
    when "app"
      App.all :conditions => {:tenant_id => current_user.tenant_id}
    when "site"
      Site.all :conditions => {:tenant_id => current_user.tenant_id}
    when "host"
      Host.all :conditions => {:tenant_id => current_user.tenant_id}
    when "device"
      Device.all :conditions => {:tenant_id => current_user.tenant_id}
    end
    @source = @app || @site || @host || @device
    @services = @source.services if @source
  end

  def dict
    submenu_item 'reports-availability'
    #@dates = [['最近24小时(Last 24 hours)','last24hours'],['今天(Today)','today'],['昨天(Yesterday)','yesterday'],['本周(This Week)','thisweek'],['最近7天(Last 7 days)','last7days'],['本月(This Month)','thismonth'],['最近30天(Last 30 days)','last30days']]
    d = ['last24hours','today','yesterday','thisweek','last7days','thismonth','last30days']
    @dates = d.collect { |x| [I18n.t(x), x ] }
    @date_range = parse_date_range(params[:date])
    @date = @date_range[:param]
    @human_date = @date_range[:human]
    @tabs = [["site", "网站", sites_avail_path],["host", "主机", hosts_avail_path],["app", "应用", apps_avail_path],["device", "网络", devices_avail_path],["service", "服务", services_avail_path]]
  end

end
