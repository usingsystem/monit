class AlertsController < ApplicationController
  menu_item 'alerts'
  def index
    submenu_item 'alerts-index'
    @alerts = Alert.paginate query(:page => params[:page])
    status_tab
    dictionary
  end

  private
  def query options = {}
    order_option options
    con = conditions
    con.update :severity => Alert.severity.index(params[:severity]) unless params[:severity].blank?
    options.update({
      :include => ['service'] + Alert.source_names,
      :conditions => con
    })
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :source_type => 1, :source_id => @host.id if @host
    con.update :source_type => 2, :source_id => @app.id if @app
    con.update :source_type => 3, :source_id => @site.id if @site
    con.update :source_type => 4, :source_id => @device.id if @device
    con
  end

  def status_tab
    stat = Alert.all :select => "severity, count(*) num", :group => "severity", :conditions => conditions

    @status_tab = []
    Alert.severity.each do |s|
      @status_tab.push [s, t('status.alert.' + s), 0, filter_params(params, {:severity => s})]
    end
    n = 0
    stat.each do |s|
      @status_tab[s.severity][2] = s.num.to_i
      n = n + s.num.to_i
    end
    @status_tab.unshift ['all', t('all'), n, filter_params(params, {:severity => nil})]
    @current_status_name = params[:severity].blank? ? 'all' : params[:severity]
  end
  def dictionary
  end
end
