# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  include UiHelper
  attr :title

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :login_required
  #before_filter :reset_tenant

  before_filter :system_path, :if => :logged_in?
  before_filter :find_operator
  # around_filter :record_memory

  #tenant_aware Host,App,Service,Alert,Agent

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  #

#  after_filter  :log_operation

  def find_operator
    @operator=current_user

#    @operator=Operator.first
  end
  
  def system_path
    @path = [[t("monit"), {:controller => "dashboard"}]]
    path = []
    path_params = params.dup
    #    parents = [Service, App, Host]
    #    parents.each do |p|
    #      id = path_params[p.name.downcase + "id"]
    #    end
    if !path_params[:service_id].blank?
      service = Service.find path_params[:service_id], :conditions =>{ :tenant_id => current_user.tenant_id}
      path_params.clear
      if service
        @service = service
        path << [service.name, service]
        path_params[(service.serviceable_name + "_id").to_sym] = service.serviceable_id
      end
    end
    if !path_params[:app_id].blank?
      app = App.find path_params[:app_id], :conditions =>{ :tenant_id => current_user.tenant_id}
      path_params.clear
      if app
        @app = app
        path << [app.name, app]
        path_params[:host_id] = app.host_id
      end
    elsif !path_params[:site_id].blank?
      site = Site.find path_params[:site_id], :conditions =>{ :tenant_id => current_user.tenant_id}
      path_params.clear
      if site
        @site = site
        path << [site.name, site]
        #path_params[:host_id] = site.host_id
      end
    end
    if !path_params[:host_id].blank?
      host = Host.find path_params[:host_id], :conditions =>{ :tenant_id => current_user.tenant_id}
      path_params.clear
      if host
        @host = host
        path << [host.name, host]
      end
    end
    if !path_params[:device_id].blank?
      device = Device.find path_params[:device_id], :conditions =>{ :tenant_id => current_user.tenant_id}
      path_params.clear
      if device
        @device = device
        path << [device.name, device]
      end
    end
    @path = @path + path.reverse
    @path << [t(controller_name), {:controller => controller_name, :action => "index", :host_id => params[:host_id], :app_id => params[:app_id], :site_id => params[:site_id], :service_id => params[:service_id], :device_id => params[:device_id]}]
  end

  def menu_item value=nil
    if value.nil?
      self.class.read_inheritable_attribute(:menu_item_new) || self.class.read_inheritable_attribute(:menu_item)
    else
      self.class.write_inheritable_attribute(:menu_item_new,value)
    end
  end

  def submenu_item value=nil
    if value.nil?
      @submenu_item
    else
      @submenu_item = value
    end
  end

  def redirect_to_with_param options = {}, response_status = {}
    options = params[:redirect_to] unless params[:redirect_to].blank?
    redirect_to_without_param options, response_status
  end
  alias_method_chain :redirect_to, :param

  def record_memory
    process_status = File.open("/proc/#{Process.pid}/status")
    13.times { process_status.gets }
    rss_before_action = process_status.gets.split[1].to_i
    process_status.close
    yield
    process_status = File.open("/proc/#{Process.pid}/status")
    13.times { process_status.gets }
    rss_after_action = process_status.gets.split[1].to_i
    process_status.close
    logger.info("CONSUME MEMORY: #{rss_after_action - rss_before_action} \
                  KB\tNow: #{rss_after_action} KB\t#{request.url}")
  end

   def  select_date(date)
    now = Time.now
    if date=='last24hours'
      @start=now - 24*60*60
      @finish=now
    end
    if date=='today'
      @start=now.at_beginning_of_day
      @finish=now
    end
    if date=='yesterday'
      @start=now.at_beginning_of_day - 24*60*60
      @finish=now.at_beginning_of_day
    end
    if date=='thisweek'
      @start=now.at_beginning_of_week
      @finish=now
    end
    if date=='last7days'
      @start=now - 7*24*60*60
      @finish=now
    end
    if date=='thismonth'
      @start=now.at_beginning_of_month
      @finish=now
    end
    if date=='last30days'
      @start=now - 30*24*60*60
      @finish=now
    end
  end

   def status_tab(source_name=controller_name.classify)
     source=source_name.instance_of?(Class) ? source_name : source_name.constantize
     @status_tab = []
     source.status.each do |s|
       @status_tab.push [s, t("status.#{source.name.downcase}." + s), 0, filter_params(params, {:status => s})]
     end
     stat= if block_given?
       yield source
     else
       []
     end
     n = 0
     stat.each do |s|
       @status_tab[s.status][2] += s.num.to_i
       n = n + s.num.to_i
     end
     @status_tab.unshift ['all', t('all'), n, filter_params(params, {:status => nil})]
     @current_status_name = params[:status].blank? ? 'all' : params[:status]
   end

  private

  def parse_date_range date = nil
    if date.blank?
      date = Date.today.to_s
    end
    date = date.split(",")
    start = Date.parse(date[0])
    if date[1].blank?
      finish = start
    else
      finish = Date.parse(date[1])
    end
    start, finish = finish, start if start > finish
    if start == finish
      param = start.to_s
    else
      param = "#{start.to_s},#{finish.to_s}"
    end
    finish = finish + 1
    num = (finish - start).to_i
    start = Time.parse(start.to_s).to_i
    finish = Time.parse(finish.to_s).to_i
    {:start => start, :finish => finish,:human => param, :param => param, :n => num}
  end

  def parse_sort sort
    return {:name =>nil,:direction =>nil } if(sort.nil? || sort.empty?)
    if sort[0]!=45
      direction = "ASC"
    else
      direction = "DESC"
      sort = sort.gsub(/^\-/,"")
    end
    {:name => sort,:direction => direction }
  end

  def order_option options = {}, table_name = ""    
    sort = parse_sort params[:sort]
    table_name = (table_name.nil? || table_name.empty?) ? "" : table_name + "."
    unless sort[:name].nil?
      options.update(:order => "#{table_name}#{sort[:name]} #{sort[:direction]}")
    else
      options.update(:order => "#{table_name}id DESC")
    end
    options
  end

  def ids
    pids = params[:ids]
    @ids || (@ids = pids.is_a?(Hash) ? pids.keys : (pids.is_a?(Array) ? pids : pids.to_s.split(",")))
  end

  def log_operation
    unless params[:format] == 'ajax' or current_user.nil?
      if response.status == "200 OK" or response.status=="302 Found"
        result="成功"
        details="请求成功"
        if response.body=~/^\{success: false/
          result="失败"
          details=response.body
        end
      else
        result="失败"
        details="请求失败"
      end
    
      if params[:action]!="index"
        LogmOperation.new(
          :sessions =>request.session_options[:id],
          :user_id=>current_user.id,
          :user_name=>current_user.login,
          :action=>params[:action],
          :result=>result,
          :details=>details,
          :module_name=>params[:controller],
          :terminal_ip=>request.remote_ip).save
      end
    end
  end

  class << self
    def menu_item name
      write_inheritable_attribute(:menu_item, name)
    end
  end

end
