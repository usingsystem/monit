class HostsController < ApplicationController
  menu_item 'hosts'
  #套餐使用限制验证
  before_filter :authenticate_package, :only => [:new, :create]

  # GET /hosts
  # GET /hosts.xml
  # Parameters:
  # :as 表示显示的方式，目前支持两种: :table 表格方式, :thumbnail 缩略图方式
  # :state 表示主机状态，如果为空则显示所有主机
  def index
    submenu_item 'hosts-index'
    @hosts = Host.paginate query(:page => params[:page])
    @groups = Group.all :select=>"distinct groups.id, groups.name", :joins=>"inner join hosts h on h.group_id=groups.id and h.tenant_id=#{current_user.tenant_id}"
    @groups.each { |g|
      g.name=g.id==1? g.name : g.name[g.name.index('/')..-2]
    }
    dictionary
    status_tab

    respond_to do |format|
      format.html {# index.html.erb
        render :action => ['icon'].index(params[:view]).nil? ? 'index' : params[:view]
      }
      format.xml  { render :xml => @hosts }
    end
  end

  # POST /hosts/1
  # POST /hosts/1.xml
  def test_snmp
    @host = Host.find(params[:id], query)
    result = snmpget
    if result.empty?
      flash[:error] = "SNMP测试不通，请检查主机上SNMP代理配置<br />团体名：#{@host.community}  端口：#{@host.port} 版本：#{@host.snmp_ver}"
    else
      flash[:notice] = "SNMP测试通过。"
    end
    redirect_to :back
  end

  # GET /hosts/1
  # GET /hosts/1.xml
  def show
    @host = Host.find(params[:id], query)
    @services = @host.services
    @alerts = Alert.all({
        :conditions => ["source_type = 1 and source_id = ? and severity <> 0", @host.id]
      })
    @ctrl_service = @host.ctrl_service
    #@status = Status.new(@ctrl_service)
    #now = Time.now
    #now = Time.parse("2010-4-18 12:00") #for test
    #@data = @status.history({:start => now - 24*60*60, :finish => now})
    #@view = Status.host_view(@data)

    @disco_services = DiscoService.all(:conditions => ["disco_services.serviceable_type = 1 and disco_services.serviceable_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", @host.id])



    #@metric = @host.metric
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { 
        #render :xml => @host 
      }
    end
  end

  # GET /hosts/1/view
  def view
    @host = Host.find(params[:id], query)
    @services = Service.all :conditions => { :serviceable_type => 1, :serviceable_id => @host.id }, :include => ['type', 'history_views']
  end

  # GET /hosts/1/live
  def live
    @host = Host.find(params[:id], query)
    @services = @host.services
    @services = Service.all :conditions => { :serviceable_type => 1, :serviceable_id => @host.id }, :include => ['type', 'default_view']
  end

  # GET /hosts/1/ctrl
  def ctrl
    @host = Host.find(params[:id], :conditions => conditions)
  end

  # PUT /hosts/1/ctrl_update
  def ctrl_update
    @host = Host.find(params[:id], :conditions => conditions)
    cond = {:serviceable_id => @host.id, :serviceable_type => 1}
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
    redirect_to @host
  end

  def select
  end

  # GET /hosts/new
  # GET /hosts/new.xml
  def new
    submenu_item 'hosts-new'
    @host = Host.new({:is_support_snmp => 1, :snmp_ver => "v2c", :port => 161, :community => "public"})
    @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
    #:is_support_remote => (params[:support] == "remote") ? 1 : 0, :snmp_ver => "v2c", :port => 161, :community => "public", :is_support_snmp => 1
    dictionary

    respond_to do |format|
      format.html
      format.xml  { render :xml => @host }
    end
  end

  # GET /hosts/1/edit
  def edit
    @host = Host.find(params[:id], :conditions => conditions)
    @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
    dictionary
  end

  def edit_snmp
    @host = Host.find(params[:id], :conditions => conditions)
    dictionary
  end

  def edit_notification
    @host = Host.new
    @hosts = Host.find(ids, :conditions => conditions)
    if @hosts.size == 0
      flash[:error] =  "请选择#{I18n.t('host')}。"
      redirect_to :back and return
    end
  end

  def batch_update
    attr = params[:host]
    @hosts = Host.find(ids, :conditions => conditions)
    @hosts.each do |host|
      host.update_attributes(attr)
    end
    if @hosts.size == 0
      flash[:error] =  "请选择#{I18n.t('host')}。"
    else
      flash[:notice] = "成功更新#{@hosts.size}个#{I18n.t('host')}。"
    end
    redirect_to hosts_url
  end

  #GET /hosts/1/disco.ajax
  def disco
    @host = Host.find(params[:id], :conditions => conditions)
    @disco_services = DiscoService.all(:conditions => {:serviceable_type => 1, :serviceable_id => @host.id })
    respond_to do |format|
      format.ajax{
      }
    end
  end

  # PUT /hosts/1/redesco
  def redisco
    @host = Host.find(params[:id], :conditions => conditions)
    @host.update_attributes(:discovery_state => 2)
    flash[:notice] = "正在重新发现#{@host.name}的服务。"
    respond_to do |format|
      format.html{
        redirect_to :back
      }
    end
  end

  # POST /hosts
  # POST /hosts.xml
  def create
    submenu_item 'hosts-new'
    @host = Host.new({"is_support_snmp" => 1, "snmp_ver" => "v2c", "port" => 161, "community" => "public"}.update(params[:host]))
    @host.tenant_id = current_user.tenant_id

    respond_to do |format|
      if @host.save
        #set_preferences @host.is_support_remote, @host.is_support_snmp
        flash[:notice] = "#{@host.name}创建成功。"
        format.html { redirect_to(@host) }
        format.xml  { render :xml => @host, :status => :created, :location => @host }
      else
        dictionary
        @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
        format.html { render :action => "new" }
        format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hosts/1
  # PUT /hosts/1.xml
  def update
    @host = Host.find(params[:id], :conditions => conditions)
    respond_to do |format|
      if @host.update_attributes(params[:host])
        flash[:notice] = "#{@host.name}更新成功。"
        format.html { redirect_to(@host) }
        format.xml  { head :ok }
      else
        dictionary
        @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
        format.html { render :action => "edit" }
        format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
      end
    end
  end

  def confirm
    @host = Host.find(params[:id], :conditions => conditions)
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.xml
  def destroy
    @host = Host.find(params[:id], :conditions => conditions)
    unless @host.is_support_agent?
      @host.destroy 
      flash[:notice] = "#{@host.name}删除成功。"
    else
      flash[:error] = "#{@host.name}上安装有代理，不能删除。"
    end
    respond_to do |format|
      format.html { redirect_to(hosts_url) }
      format.xml  { head :ok }
    end
  end

  def config
    @host=Host.find(params[:id])
    @info=HostConfig.configinfo(@host)
    @result={} 
    @info.each{|key,v|
     h={}
      v.each{|k,v|        
        hsh={}
        arr=v.split(",")
        for i in 0...arr.length
          hsh[arr[i].split("=")[0]] = arr[i].split("=")[1]
        end
        h[k]=hsh
      }
      @result[key]=h
    }
  end

  private

  #def set_preferences remote, snmp
  #  current_user.prefers_host_support_remote = remote
  #  current_user.prefers_host_support_snmp = snmp
  #  current_user.save!
  #end

  #def snmpget ip, ver, port, community
  #  res = `snmpget -v #{ver} -c #{community} #{ip}:#{port} sysDescr.0`
  #end

  def snmpget
    res = `snmpget -t 2 -r 1 -v #{@host.snmp_ver[1..-1]} -c #{@host.community} #{@host.addr}:#{@host.port} sysDescr.0`
  end

  def dictionary
    @host_types = HostType.all
    @agents = Agent.all :include => ['host'], :conditions => {:tenant_id => current_user.tenant_id}
  end

  def query options = {}
    order_option options

    con = conditions
    con.update :status => Host.status.index(params[:status]) unless params[:status].blank?

    options.update({
        :include => ['type', 'apps', 'services'],
        :conditions => con.size == 0 ? nil:con
      })
  end
  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :group_id => Group.all(:conditions=>["name like concat(?,'%')",params[:group]]) unless params[:group].blank?
    con.update :type_id => HostType.all(:conditions => ["name like concat(?,'%')", params[:type]]) unless params[:type].blank?
    con
  end
  def status_tab
    stat = Host.all :select => "status, count(*) num", :group => "status", :conditions => conditions

    @status_tab = []
    Host.status.each do |s|
      @status_tab.push [s, t('status.host.' + s), 0, filter_params(params, {:status => s})]
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
