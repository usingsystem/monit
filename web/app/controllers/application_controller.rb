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
  before_filter :authenticate_operator

  before_filter :system_path, :if => :logged_in?
  #before_filter :user_permissions,:root_required,:except => [:login,:logout]
  # around_filter :record_memory
  #tenant_aware Host,App,Service,Alert,Agent

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  #

  after_filter  :log_operation


  #url层过滤权限
  def root_required

    unless ["sessions","dashboard","welcome","search","accounts"].include? params[:controller]
      if @current_user.role.id !=1
        unless Permission.find_by_sql("select id from permissions where controller_name like '%#{params[:controller]}%' and action_name like '%#{params[:action]}%' and default_permission=false").empty?
          params[:action] ||= "index"
          ctl_action = params[:controller]+"/"+ params[:action]
          unless  @user_permissions.include?(ctl_action)
            redirect_to  "/no_permission.html" and return
          end
        end
      end
    end
  end

  def user_permissions
    @user_permissions=[]
    unless current_user.nil?
      unless current_user.role.nil?
        unless current_user.role.permissions.nil?
          current_user.role.permissions.each do |p|
            user_p = []
            pcs= p.controller_name.split(",").to_a;
            pas=p.action_name.split(",").to_a;
            pcs.each do |pc|
              pas.each do |pa|
                user_p << pc+"/"+pa
              end
            end
            @user_permissions << user_p
            @user_permissions.uniq!
            @user_permissions.flatten!
          end
          return @user_permissions
        end
      end
    end
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
      @menu_item || self.class.read_inheritable_attribute(:menu_item)
    else
      @menu_item = value
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

  def select_date(date)
    now = Time.now
    now = Time.parse("2010-7-13 14:30") if RAILS_ENV == 'development' #For test
    if date=='today'
      @start=now.at_beginning_of_day
      @finish=now
    elsif date=='yesterday'
      @start=now.at_beginning_of_day - 1.day
      @finish=now.at_beginning_of_day
    elsif date=='thisweek'
      @start=now.at_beginning_of_week
      @finish=now
    elsif date=='last7days'
      @start=now - 7.days
      @finish=now
    elsif date=='thismonth'
      @start=now.at_beginning_of_month
      @finish=now
    elsif date=='last30days'
      @start=now - 30.days
      @finish=now
    else
      # date=='last24hours'
      @start=now - 1.day
      @finish=now
    end
  end

  private
  def availablities(status,object)
    s=status.history(:start=>@start,:finish=>@finish)
    sta = {"ok" => 0, "warning" => 0, "unknown" => 0, "critical" => 0, "pending"=>0}
    if s.length>0
      s.each do |key, val|
        sta.each do |k,v|
          sta[k] = val[k].to_i + sta[k]
        end
      end
      sta.each { |k,v|
        sta["sum"] ||=0
        sta["sum"]+=v.to_f
      }
      sum=sta["sum"]
      sta.each { |k,v|
        sta[k]=v.to_f/sum
      }
      sta["name"]=object.name
      sta["id"]=object.id
      sta[:object] = object
      sta
    end
  end

  def status_object name, model, status
    i = -1
    model.status.collect do |x|
      i = i + 1
      {
        :id => i,
        :name => x,
        :color => model.status_colors[i],
        :title => I18n.t("status.#{name}.#{x}"),
        :num => status[i] || 0
      }
    end
  end

  def parse_date_range date = nil
    now = Time.now
    now = Time.parse("2010-7-13 14:30") if RAILS_ENV == 'development' #For test
    if date == 'today'
      start = now.at_beginning_of_day
      finish = now
      human = I18n.t(date)
    elsif date == 'yesterday'
      start = now.at_beginning_of_day - 1.day
      finish = now.at_beginning_of_day
      human = I18n.t(date)
    elsif date == 'thisweek'
      start = now.at_beginning_of_week
      finish = now
      human = I18n.t(date)
    elsif date == 'last7days'
      start = now - 7.days
      finish = now
      human = I18n.t(date)
    elsif date == 'thismonth'
      start = now.at_beginning_of_month
      finish = now
      human = I18n.t(date)
    elsif date == 'last30days'
      start = now - 30.days
      finish = now
      human = I18n.t(date)
    elsif date.blank?
      date = "last24hours"
    else
      da = date.split(",")
      begin
        start = Date.parse(da[0])
        if da[1].blank?
          finish = start
        else
          finish = Date.parse(da[1])
        end
        start, finish = finish, start if start > finish
        if start == finish
          human = start.to_s
          date = start.to_s
        else
          human = "#{start.to_s}到#{finish.to_s}"
          date = "#{start.to_s},#{finish.to_s}"
        end
        start = start.to_time
        finish = (finish + 1).to_time
      rescue ArgumentError
        date = "last24hours"
      end
    end
    if date == "last24hours"
      start = now - 1.day
      finish = now
      human = I18n.t(date)
    end
    num = (finish - start).to_i
    {:start => start, :finish => finish,:human => human, :param => date, :n => num}
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

  def xls_content_for(data_key,history_result1)
    xls_report = StringIO.new
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Trends"

    blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10
    sheet1.row(0).default_format = blue

    sheet1.row(0).concat data_key
    count_row = 1
    history_result1.each do |obj|
      j=obj.length-1
      i=0
      for i in 0..j
        sheet1[count_row,i]=obj[i]
      end
      count_row += 1
    end
    book.write xls_report
    xls_report.string
  end


  def authenticate_operator
    host = request.host
    host = "www.monit.cn" if ["localhost", "0.0.0.0", "test.com"].include?(host) #or RAILS_ENV == 'development'
    @operator = Operator.find_by_host(host)
    unless @operator
      render :text => "您需要获得Monit经营授权后才能访问，<a href='http://www.monit.cn/contact'>联系我们</a>。", :status => 400 and return
    end
  end

  def authenticate_package
    tenant = current_user.tenant
    package = tenant.package
    is_admin = current_user.is_admin?
    url = is_admin ? tenant_url : edit_account_url
    if tenant.is_paid?
      if (self.class == HostsController and tenant.is_host_full?) or tenant.is_service_full?
        flash[:error] = is_admin ? "您的监控额度已满，您需要升级套餐后才能添加更多监控。" : "您的监控额度已满，请联系您的管理员升级套餐。"
        redirect_to_without_param url
      end
    else
      flash[:error] = is_admin ? "您需要为你的套餐付费后才能添加监控。" : "您的帐户还未付费，请联系您的管理员。"
      redirect_to_without_param url
    end
  end

  class << self
    def menu_item name
      write_inheritable_attribute(:menu_item, name)
    end
  end

end
