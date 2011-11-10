# To change this template, choose Tools | Templates
# and open the template in the editor.

class AppsController < ApplicationController
  #套餐使用限制验证
  before_filter :authenticate_package, :only => [:new, :create]
  menu_item 'applications'

  # Parameters:
  # :as 表示显示的方式，目前支持两种: :table 表格方式, :thumbnail 缩略图方式
  # :state 表示应用状态，如果为空则显示所有应用
  def index
    submenu_item 'applications-index'
    @apps = App.paginate query(:page => params[:page])
    @groups = Group.all :select=>"distinct groups.id,groups.name",:joins=>"inner join apps a on a.group_id=groups.id and a.tenant_id=#{current_user.tenant_id}"
    @groups.each { |g|
      g.name=g.id==1? g.name : g.name[g.name.index('/')..-2]
    }
    dictionary
    status_tab
    respond_to do |format|
      format.html {
       # index.html.erb
        render :action => ['icon'].index(params[:view]).nil? ? 'index' : params[:view]
      }
      format.xml  { render :xml => @apps }
    end
  end

  # GET /hosts/1
  # GET /hosts/1.xml
  def show
    submenu_item 'applications-index'
    @app = App.find(params[:id], query)
    @alerts = Alert.all({
        :conditions => ["source_type = 2 and source_id = ? and severity <> 0", @app.id]
      })
    @services = @app.services
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @app }
    end
  end

  # GET /hosts/new
  # GET /hosts/new.xml
  def new
    submenu_item 'applications-new'
    @app = App.new(:type_id => params[:type_id], :host_id => params[:host_id])
    @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
    unless @app.type
      redirect_to params.update(:action => "types")
      return
    end
    dictionary
    respond_to do |format|
      format.html{
      }
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/1/ctrl
  def ctrl
    @app = App.find(params[:id], :conditions => conditions)
  end

  # PUT /apps/1/ctrl_update
  def ctrl_update
    @app = App.find(params[:id], :conditions => conditions)
    cond = {:serviceable_id => @app.id, :serviceable_type => 2}
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
    redirect_to @app
  end

  def types
    submenu_item 'applications-new'
    @app_types = AppType.all :conditions => {:level => 2}
    @hosts = Host.all :conditions =>{ :tenant_id => current_user.tenant_id}
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @app }
    end
  end

  # GET /hosts/1/edit
  def edit
    submenu_item 'applications-index'
    @app = App.find(params[:id], :conditions => conditions)
    @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
    dictionary
  end

  def edit_notification
    @app = App.new
    @apps = App.find(ids, :conditions => conditions)
    if @apps.size == 0
      flash[:error] =  "请选择#{I18n.t('app')}。"
      redirect_to :back and return
    end
  end

  def batch_update
    attr = params[:app]
    @apps = App.find(ids, :conditions => conditions)
    @apps.each do |app|
      app.update_attributes(attr)
    end
    if @apps.size == 0
      flash[:error] =  "请选择#{I18n.t('app')}。"
    else
      flash[:notice] = "成功更新#{@apps.size}个#{I18n.t('app')}。"
    end
    redirect_to apps_url
  end

  # POST /hosts
  # POST /hosts.xml
  def create
    submenu_item 'applications-new'
    @app = App.new(params[:app])
    @app.tenant_id = current_user.tenant_id
    respond_to do |format|
      if @app.save
        flash[:notice] = "#{@app.name}创建成功"
        format.html { redirect_to(@app) }
        format.xml  { render :xml => @app, :status => :created, :location => @app }
      else
        dictionary
        @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
        format.html { render :action => "new" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hosts/1
  # PUT /hosts/1.xml
  def update
    @app = App.find(params[:id], :conditions => conditions)
    params[:app].delete :type_id
    respond_to do |format|
      if @app.update_attributes(params[:app])
        flash[:notice] = "#{@app.name}更新成功。"
        format.html { redirect_to(@app) }
        format.xml  { head :ok }
      else
        dictionary
        @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
        format.html { render :action => "edit" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  def confirm
    @app = App.find(params[:id], :conditions => conditions)
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.xml
  def destroy
    @app = App.find(params[:id], :conditions => conditions)
    @app.destroy
    flash[:notice] = "#{@app.name}删除成功"
    respond_to do |format|
      format.html { redirect_to(apps_url) }
      format.xml  { head :ok }
    end
  end

   def config
     @app=App.find(params[:id])
     @info=HostConfig.configinfo(@app)
  end

  private

  def dictionary
    @app_types = AppType.all
    @hosts = Host.all :conditions =>{ :tenant_id => current_user.tenant_id}
  end

  def query options = {}
    order_option options
    con = conditions
    con.update :status => App.status.index(params[:status]) unless params[:status].blank?

    #:select => "apps.*,t1.name host_name,t2.service_num",
    #:joins => "left join hosts t1 on t1.id = apps.host_id 
    #           left join (select serviceable_id,count(*) service_num from services where serviceable_type=2 group by serviceable_id ) t2 on t2.serviceable_id = apps.id
    #",
    options.update({
        :include => ['type', 'host', 'services'],
        :conditions => con.size == 0 ? nil:con
      })
  end
  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :group_id => Group.all(:conditions=>["name like concat(?,'%')",params[:group]]) unless params[:group].blank?
    con.update :type_id => AppType.all(:conditions => ["name like concat(?,'%')", params[:type]]) unless params[:type].blank?
    con
  end
  def status_tab
    stat = App.all :select => "status, count(*) num", :group => "status", :conditions => conditions
    @status_tab = []
    App.status.each do |s|
      @status_tab.push [s, t('status.app.' + s), 0, filter_params(params, {:status => s})]
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
