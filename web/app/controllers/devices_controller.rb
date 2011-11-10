class DevicesController < ApplicationController
  #套餐使用限制验证
  before_filter :authenticate_package, :only => [:new, :create]
  menu_item 'networks'

  # GET /devices
  # GET /devices.xml
  # Parameters:
  # :as 表示显示的方式，目前支持两种: :table 表格方式, :thumbnail 缩略图方式
  # :state 表示主机状态，如果为空则显示所有主机
  def index
    submenu_item 'devices-index'
    @devices = Device.paginate query(:page => params[:page])
    @groups = Group.all :select=>"distinct groups.id ,groups.name", :joins=>"inner join devices d on d.group_id = groups.id and d.tenant_id=#{current_user.tenant_id}"
    @groups.each { |g|
      g.name=g.id==1? g.name : g.name[g.name.index('/')..-2]
    }
    dictionary
    status_tab

    respond_to do |format|
      format.html {# index.html.erb
        render :action => ['icon'].index(params[:view]).nil? ? 'index' : params[:view]
      }
      format.xml  { render :xml => @devices }
    end
  end

  # POST /devices/1
  # POST /devices/1.xml
  def test_snmp
    @device = Device.find(params[:id], query)
    result = snmpget
    if result.empty?
      flash[:error] = "SNMP测试不通，请检查设备上SNMP代理配置<br />团体名：#{@device.community}  端口：#{@device.port} 版本：#{@device.snmp_ver}"
    else
      flash[:notice] = "SNMP测试通过。"
    end
    redirect_to :back
  end

  # GET /devices/1
  # GET /devices/1.xml
  def show
    @device = Device.find(params[:id], query)
    @services = @device.services
    #@apps = @device.apps
    @alerts = Alert.all({
        :conditions => ["source_type = 4 and source_id = ? and status <> 0", @device.id]
      })
    @disco_services = DiscoService.all(:conditions => ["disco_services.serviceable_type = 4 and disco_services.serviceable_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", @device.id])

    #@metric = @device.metric
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { 
        #render :xml => @device 
      }
    end
  end

  # GET /devices/1/ctrl
  def ctrl
    @device = Device.find(params[:id], :conditions => conditions)
  end

  # PUT /devices/1/ctrl_update
  def ctrl_update
    @device = Device.find(params[:id], :conditions => conditions)
    cond = {:serviceable_id => @device.id, :serviceable_type => 4}
    @ctrl = Service.find(params[:ctrl], :conditions => cond)
    if @ctrl 
      unless @ctrl.is_ctrl?
        Service.update_all({:ctrl_state => 0}, cond)
        @ctrl.update_attribute("ctrl_state", 1)
      end
      flash[:notice] = "修改成功。"
    else
      flash[:error] = "What are you doing?"
    end
    redirect_to @device
  end

  def select
  end

  # GET /devices/new
  # GET /devices/new.xml
  def new
    submenu_item 'devices-new'
    @device = Device.new({:is_support_snmp => 1, :snmp_ver => "v2c", :port => 161, :community => "public"})
    @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
    #:is_support_remote => (params[:support] == "remote") ? 1 : 0, :snmp_ver => "v2c", :port => 161, :community => "public", :is_support_snmp => 1
    dictionary

    respond_to do |format|
      format.html
      format.xml  { render :xml => @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id], :conditions => conditions)
    @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
    dictionary
  end

  def edit_notification
    @device = Device.new
    @devices = Device.find(ids, :conditions => conditions)
    if @devices.size == 0
      flash[:error] =  "请选择#{I18n.t('device')}。"
      redirect_to :back and return
    end
  end

  def batch_update
    attr = params[:device]
    @devices = Device.find(ids, :conditions => conditions)
    @devices.each do |device|
      device.update_attributes(attr)
    end
    if @devices.size == 0
      flash[:error] =  "请选择#{I18n.t('device')}。"
    else
      flash[:notice] = "成功更新#{@devices.size}个#{I18n.t('device')}。"
    end
    redirect_to devices_url
  end

  def edit_snmp
    @device = Device.find(params[:id], :conditions => conditions)
    dictionary
  end

  #GET /devices/1/disco.ajax
  def disco
    @device = Device.find(params[:id], :conditions => conditions)
    @disco_services = DiscoService.all(:conditions => {:serviceable_type => 4, :serviceable_id => @device.id })
    respond_to do |format|
      format.ajax{
      }
    end
  end

  # PUT /devices/1/redesco
  def redisco
    @device = Device.find(params[:id], :conditions => conditions)
    @device.update_attributes(:discovery_state => 2)
    flash[:notice] = "正在重新发现#{@device.name}的服务。"
    respond_to do |format|
      format.html{
        redirect_to :back
      }
    end
  end

  # POST /devices
  # POST /devices.xml
  def create
    submenu_item 'devices-new'
    @device = Device.new({"is_support_snmp" => 1, "snmp_ver" => "v2c", "port" => 161, "community" => "public"}.update(params[:device]))
    @device.tenant_id = current_user.tenant_id

    respond_to do |format|
      if @device.save
        #set_preferences @device.is_support_remote, @device.is_support_snmp
        flash[:notice] = "#{@device.name}创建成功。"
        format.html { redirect_to(@device) }
        format.xml  { render :xml => @device, :status => :created, :location => @device }
      else
        dictionary
        @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
        format.html { render :action => "new" }
        format.xml  { render :xml => @device.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.xml
  def update
    @device = Device.find(params[:id], :conditions => conditions)
    respond_to do |format|
      if @device.update_attributes(params[:device])
        flash[:notice] = "#{@device.name}更新成功。"
        format.html { redirect_to(@device) }
        format.xml  { head :ok }
      else
        dictionary
        @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
        format.html { render :action => "edit" }
        format.xml  { render :xml => @device.errors, :status => :unprocessable_entity }
      end
    end
  end

  def confirm
    @device = Device.find(params[:id], :conditions => conditions)
  end

  # DELETE /devices/1
  # DELETE /devices/1.xml
  def destroy
    @device = Device.find(params[:id], :conditions => conditions)
    unless @device.is_support_agent?
      @device.destroy 
      flash[:notice] = "#{@device.name}删除成功。"
    else
      flash[:error] = "#{@device.name}上安装有代理，不能删除。"
    end
    respond_to do |format|
      format.html { redirect_to(devices_url) }
      format.xml  { head :ok }
    end
  end
  private
  def snmpget
    res = `snmpget -t 2 -r 1 -v #{@device.snmp_ver[1..-1]} -c #{@device.community} #{@device.addr}:#{@device.port} sysDescr.0`
  end

  def dictionary
    @device_types = DeviceType.all
    @agents = Agent.all :include => ['host'], :conditions => {:tenant_id => current_user.tenant_id}
  end

  def query options = {}
    order_option options

    con = conditions
    con.update :status => Device.status.index(params[:status]) unless params[:status].blank?

    options.update({
        :include => ['type', 'services'],
        :conditions => con.size == 0 ? nil:con
      })
  end
  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :group_id => Group.all(:conditions=>["name like concat(?,'%')",params[:group]]) unless params[:group].blank?
    con.update :type_id => DeviceType.all(:conditions => ["name like concat(?,'%')", params[:type]]) unless params[:type].blank?
    con
  end
  def status_tab
    stat = Device.all :select => "status, count(*) num", :group => "status", :conditions => conditions

    @status_tab = []
    Device.status.each do |s|
      @status_tab.push [s, t('status.device.' + s), 0, filter_params(params, {:status => s})]
    end
    n = 0
    stat.each do |s|
      @status_tab[s.status][2] = s.num.to_i
      n = n + s.num.to_i
    end
    @status_tab.unshift ['all', t('all'), n, filter_params(params, {:status => nil})]
    @current_status_name = params[:status].blank? ? 'all' : params[:status]
  end
end
