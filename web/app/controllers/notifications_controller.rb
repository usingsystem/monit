class NotificationsController < ApplicationController
  menu_item 'alerts'
  def index
    @type = Notification::TYPES.select{ |x| x[:name] == params[:type] }.first
    @type ||= Notification::TYPES.first
    submenu_item 'notifications-index'
    params[:sort] ||= "-created_at"
    @notifications = Notification.paginate query(:page => params[:page])
    status_tab
  end

  private
  def query options = {}
    order_option options
    con = conditions
    con.update :method => Notification.methods.collect{|x| x[:name]}.index(params[:method]) unless params[:method].blank?
    options.update({
      :include => ['user'],
      :conditions => con
    })
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :status => [1, 2]
    con.update :type_id => @type[:id]
    con
  end

  def status_tab
    stat = Notification.all :select => "method, count(*) num", :group => "method", :conditions => conditions

    @status_tab = []
    Notification.methods.each do |s|
      @status_tab.push [s[:name], s[:title], 0, filter_params(params, {:method => s[:name]})]
    end
    n = 0
    stat.each do |s|
      @status_tab[s.method.to_i][2] = s.num.to_i
      n = n + s.num.to_i
    end
    @status_tab.unshift ['all', t('all'), n, filter_params(params, {:method => nil})]
    @current_status_name = params[:method].blank? ? 'all' : params[:method]
  end
end
