class SitesController < ApplicationController

  #套餐使用限制验证
  before_filter :authenticate_package, :only => [:new, :create]
  
  menu_item 'sites'

  # GET /sites
  # GET /sites.xml
  def index
    submenu_item 'sites-index'
    @sites = Site.paginate query(:page => params[:page])
    @groups = Group.all :select=>"distinct groups.id, groups.name", :joins=>"inner join sites s on s.group_id=groups.id and s.tenant_id=#{current_user.tenant_id}"
    @groups.each { |g|
      g.name=g.id==1? g.name : g.name[g.name.index('/')..-2]
    }

    status_tab

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end


  # GET /sites/1
  # GET /sites/1.xml
  def show
    @site = Site.find(params[:id], :conditions => conditions)
    @alerts = Alert.all({
      :conditions => ["source_type = 3 and source_id = ? and severity <> 0",  @site.id]
    })
    @services = @site.services

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new(:url => "http://")
    dictionary
    submenu_item 'sites-new'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id], :conditions => conditions)
    dictionary
  end

   def edit_notification
    @site = Site.new
    @sites = Site.find(ids, :conditions => conditions)
    if @sites.size == 0
      flash[:error] =  "请选择#{I18n.t('site')}。"
      redirect_to :back and return
    end
  end

  def batch_update
    attr = params[:site]
    @sites = Site.find(ids, :conditions => conditions)
    @sites.each do |site|
      site.update_attributes(attr)
    end
    if @sites.size == 0
      flash[:error] =  "请选择#{I18n.t('site')}。"
    else
      flash[:notice] = "成功更新#{@sites.size}个#{I18n.t('site')}。"
    end
    redirect_to sites_url
  end

 # GET /sites/1/ctrl
  def ctrl
    @site = Site.find(params[:id], :conditions => conditions)
  end

  # PUT /sites/1/ctrl_update
  def ctrl_update
    @site = Site.find(params[:id], :conditions => conditions)
    cond = {:serviceable_id => @site.id, :serviceable_type => 3}
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
    redirect_to @site
  end

  # GET /sites/1/confirm
  def confirm
    @site = Site.find(params[:id], :conditions => conditions)
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])
    @site.tenant_id = current_user.tenant_id

    respond_to do |format|
      if @site.save
        flash[:notice] = @site.name + '创建成功。'
        format.html { redirect_to(@site) }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        dictionary
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id], :conditions => conditions)

    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = @site.name + '更新成功。'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        dictionary
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id], :conditions => conditions)
    @site.destroy
    flash[:notice] = "#{@site.name}删除成功。"

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end

  private

  def dictionary
     @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
  end

  def query options = {}
    order_option options
    con = conditions
    con.update :status => Site.status.index(params[:status]) unless params[:status].blank?
    options.update({
      :include => ['services'],
      :conditions => con
    })
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :group_id => Group.all(:conditions=>["name like concat(?,'%')",params[:group]]) unless params[:group].blank?
    con
  end

  def status_tab
    stat = Site.all :select => "status, count(*) num", :group => "status", :conditions => conditions
    @status_tab = []
    Site.status.each do |s|
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
