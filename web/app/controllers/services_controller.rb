class ServicesController < ApplicationController
  menu_item 'services'
  #套餐使用限制验证
  before_filter :authenticate_package, :only => [:new, :create, :create_from_disco, :create_all_disco]
  # GET /services
  # GET /services.xml
  def index
    submenu_item 'services-index'
    @services = Service.paginate query(:page => params[:page])
    @service_types = ServiceType.all :select =>"distinct service_types.id, service_types.name, service_types.alias, service_types.serviceable_type", :joins => "inner join services t1 on t1.type_id = service_types.id and t1.tenant_id = #{current_user.tenant_id}"
    status_tab
    session[:service_summary] = @summary
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
      format.csv  {
        send_data(@service.metric_data, :type => 'text/csv; header=present', :filename => 'chart_data.csv')
      }
    end
  end

  def summary
    status_tab
    session[:service_summary] = @summary unless session[:service_summary]
    sum = session[:service_summary] 
    @status_tab.each do |tab|

      tab[4] = true if sum[tab[0]] > tab[2]
    end
    respond_to do |format|
      format.html
      format.ajax{
        render :layout => false
      }
    end
  end

  def disco
    submenu_item 'services-disco'
    @disco_services = DiscoService.paginate(:page => params[:page], :include => ['type'] + DiscoService.serviceable_names, :conditions => ["disco_services.tenant_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", current_user.tenant_id])
  end

  def create_all_disco
    if params[:serviceable_type] and params[:serviceable_id]
      @disco_services = DiscoService.all(:conditions => ["disco_services.serviceable_type = ? and disco_services.serviceable_id = ? and tenant_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", params[:serviceable_type], params[:serviceable_id], current_user.tenant_id])
    else
      @disco_services = DiscoService.all(:conditions => ["tenant_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", current_user.tenant_id])
    end
    tenant = current_user.tenant
    @disco_services.each do |s|
      unless tenant.is_service_full?
        s.service.save
        s.destroy
      end
    end
    if @disco_services.size > 0
      flash[:notice] = "自动发现服务创建成功。"
    else
      flash[:error] = "无自动发现服务。"
    end
    redirect_to :back
  end

  def destroy_all_disco
    if params[:serviceable_type] and params[:serviceable_id]
      @disco_services = DiscoService.all(:conditions => ["disco_services.serviceable_type = ? and disco_services.serviceable_id = ? and tenant_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", params[:serviceable_type], params[:serviceable_id], current_user.tenant_id])
    else
      @disco_services = DiscoService.all(:conditions => ["tenant_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", current_user.tenant_id])
    end
    @disco_services.each do |s|
      s.destroy
    end
    if @disco_services.size > 0
      flash[:notice] = "删除成功。"
    else
      flash[:error] = "无自动发现服务。"
    end
    redirect_to :back
  end

  def create_from_disco
    @disco_service = DiscoService.find(params[:id], :conditions => {:tenant_id => current_user.tenant_id})
    @service = @disco_service.service
    if  @service.save
      flash[:notice] = "#{@service.name}创建成功。"
    else
      if @service.errors.on(:params)
        flash[:error] = "#{@service.name}已存在，忽略#{@service.name}。"
      else
        flash[:error] = "创建出错：#{@service.errors.full_messages.inspect}"
      end
    end
    @disco_service.destroy
    respond_to do |format|
      format.html {
        redirect_to :back
      }
    end  
  end

  def destroy_disco
    @disco_service = DiscoService.find(params[:id], :conditions => {:tenant_id => current_user.tenant_id})
    @disco_service.destroy
    flash[:notice] = "忽略#{@disco_service.name}。"
    respond_to do |format|
      format.html {
        redirect_to :back
      }
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
    @service = Service.find(params[:id], :conditions => conditions)
    @alerts = Alert.all({
        :conditions => ["service_id = ? and severity <> 0", @service.id]
      })
    params[:date] = Date.today.to_s if params[:date].blank?
    @date_range = parse_date_range params[:date]
    @metric = @service.metric 
    now = Time.now
    #now = Time.parse("2010-6-10 12:00") #for test
    d = @metric.history({:start => now - 24*60*60, :finish => now})
    if d.size > 0
      @history_views = @service.history_views
      @history_views.each do |view|
        view.data = d
      end
    end
    d = @metric.current 
    if d
      @default_view = @service.default_view
      @default_view.data = d if @default_view
      @current_views = @service.views
      @current_views.each do |view|
        view.data = d
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { 
        #render :xml => @service.to_xml(:dasherize => false)
      }
    end
  end

  #select host or app
  def select
    @type = params[:type]
    @hosts = Host.all :select => "id, name" , :conditions => { :tenant_id => current_user.tenant_id } if @type == "host"
    @apps = App.all :select => "id, name" , :conditions => { :tenant_id => current_user.tenant_id } if @type == "app"
    @sites = Site.all :select => "id, name" , :conditions => { :tenant_id => current_user.tenant_id } if @type == "site"
    @devices = Device.all :select => "id, name" , :conditions => { :tenant_id => current_user.tenant_id } if @type == "device"
  end

  def types
    submenu_item 'services-new'
    #@hosts = Host.all :conditions =>{ :tenant_id => current_user.tenant_id}
    if @app
      @type = "app"
      @service_types = @app.type.service_types
    elsif @site
      @type = "site"
      @service_types = ServiceType.all(:conditions => "serviceable_type = 3")
    elsif @host
      @type = "host"
      @service_types = @host.type.service_types
    elsif @device
      @type = "device"
      @service_types = @device.type.service_types
    else
      redirect_to params.update(:action => "select")
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @types }
    end
  end


  # GET /services/new
  # GET /services/new.xml

  def new
    submenu_item 'services-new'
    @service = Service.new(:type_id => params[:type_id], :check_interval => 300)
    @service_type = @service.type
    service_param

    unless @service_type
      if @app
        redirect_to types_app_services_path(@app)
      elsif @site
        redirect_to types_site_services_path(@site)
      elsif @host
        redirect_to types_host_services_path(@host)
      elsif @device
        redirect_to types_device_services_path(@device)
      else
        redirect_to params.update(:action => "select")
      end
      return
    end
    dictionary
    s = @serviceable
    @service.agent_id = @host.agent_id if @host
    @service.serviceable_id = s && s.id
    @service.name = @service_type.default_name
    @service.ctrl_state = @service_type.ctrl_state
    @service.threshold_critical = @service_type.threshold_critical
    @service.threshold_warning = @service_type.threshold_warning
    @service.check_interval = @default_check_interval
    respond_to do |format|
      format.html
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id], :conditions => conditions)
    @service_type = @service.type
    dictionary
  end

  def edit_notification
    @service = Service.new
    @services = Service.find(ids, :conditions => conditions)
    if @services.size == 0
      flash[:error] =  "请选择#{I18n.t('service')}。"
      redirect_to :back and return
    end
  end

  def edit_threshold
    @services = Service.find(ids, :conditions => conditions, :include => ['type'] + Service.serviceable_names)
    if @services.size == 0
      flash[:error] =  "请选择#{I18n.t('service')}。"
      redirect_to :back and return
    end
    unless same_type? @services
      flash[:error] =  "请选择同样类型的#{I18n.t('service')}。"
      redirect_to :back and return
    end
    @service = Service.new(:type_id => @services.first.type_id)
    @service_type = @service.type
    @service.threshold_critical = @service_type.threshold_critical
    @service.threshold_warning = @service_type.threshold_warning
  end

  def batch_update
    attr = params[:service]
    @services = Service.find(ids, :conditions => conditions)
    @services.each do |service|
      service.update_attributes(attr)
    end
    if @services.size == 0
      flash[:error] =  "请选择#{I18n.t('service')}。"
    else
      flash[:notice] = "成功更新#{@services.size}个#{I18n.t('service')}。"
    end
    redirect_to services_url
  end


  # POST /services
  # POST /services.xml
  def create
    submenu_item 'services-new'
    @service = Service.new(params[:service])
    @service_type = @service.type
    service_param

    @service.tenant_id = current_user.tenant_id

    #    service_params = Service.extract_params(params[:service])
    #    service_params = Service.extract_thresholds(service_params)
    #    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        flash[:notice] = "#{@service.name}创建成功"
        format.html { redirect_to(@service) }
      else
        dictionary
        format.html { render :action => "new" }
      end
    end
  end


  def service_param
    unless @service_type.nil?
      unless @service_type.params.nil?
        @service_type.params.each {|param|
          if param.param_type==3
            value= param.default_value.match(/\$\{(\w*)\.(\w*)\}/)
            if @host
              object=@host
            elsif @site
              object=@site
            elsif @device
              object=@device
            elsif @app
              object=@app
            end
            service_params = HostConfig.serviceparams(object.uuid,value[1])
            @result=[]
            service_params.each{|k,v|
              hsh={}
              arr=k.split(",")
              for i in 0...arr.length
                hsh[arr[i].split("=")[0]] = arr[i].split("=")[1]
              end
              @result << hsh
            }
          end
        }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
    @service = Service.find(params[:id], :conditions => conditions)
    params[:service].delete :serviceable_id
    params[:service].delete :ctrl_state
    params[:service].delete :type_id
    respond_to do |format|
      if @service.update_attributes(params[:service])
        flash[:notice] = "#{@service.name}更新成功"
        format.html { redirect_to(@service) }
        format.xml  { head :ok }
      else
        @service_type = @service.type
        dictionary
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id], :conditions => conditions)
    #不能删除主控服务
    if @service.is_ctrl?
      flash[:error] = "#{@service.name}删除失败，不能删除主控服务。"
    else
      @service.destroy
      flash[:notice] = "#{@service.name}删除成功。"
    end

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml  { head :ok }
    end
  end
  private
  def dictionary
    @serviceable_type = @service_type.serviceable_type
    @serviceable = @app || @site || @host || @device
    @agents = Agent.all :include => ['host'], :conditions => {:tenant_id => current_user.tenant_id}
    @type_name = @serviceable_type == 1 ? '主机' : '应用'
    set_check_intervals
  end

  def set_check_intervals
    package = current_user.tenant.package
    ar = package ? Service::CHECK_INTERVALS.select{|x| x[1] >= package.min_check_interval} : Service::CHECK_INTERVALS
    @check_intervals = [["选择采集频度", ""]] + ar
    default = ar.first[1]
    @default_check_interval = @service_type.check_interval > default ? @service_type.check_interval : default
  end

  def query options = {}
    order_option options
    if options[:order]
      options[:order] = options[:order].gsub("serviceable", "serviceable_type,serviceable_id") if options[:order].include? "serviceable"
    end
    con = conditions
    con.update :status => Service.status.index(params[:status]) unless params[:status].blank?
    options.update({
        :include => ['type'] + Service.serviceable_names,
        :conditions => con
      })
  end

  def same_type? services
    type_id = services.first.type_id
    dd= services.select{ |service| service.type_id == type_id }.size == services.size
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :type_id => ServiceType.find_by_name(params[:type]) unless params[:type].blank?
    con.update :serviceable_type => 1, :serviceable_id => @host.id if @host 
    con.update :serviceable_type => 2, :serviceable_id => @app.id if @app 
    con.update :serviceable_type => 3, :serviceable_id => @site.id if @site 
    con.update :serviceable_type => 4, :serviceable_id => @device.id if @device
    con
  end

  def status_tab
    stat = Service.all :select => "status, count(*) num", :group => "status", :conditions => conditions

    @status_tab = []
    Service.status.each do |s|
      @status_tab.push [s, t('status.service.' + s), 0, filter_params(params, {:status => s})]
    end
    n = 0
    stat.each do |s|
      @status_tab[s.status][2] = s.num.to_i
      n = n + s.num.to_i
    end
    @status_tab.unshift ['all', t('all'), n, filter_params(params, {:status => nil})]
    @current_status_name = params[:status].blank? ? 'all' : params[:status]
    @summary = @status_tab.inject({}) do |h, x|
      h[x[0]] = x[2] 
      h
    end
  end
end
