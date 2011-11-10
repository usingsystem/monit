class RolesController < ApplicationController

  menu_item 'accounts'
  skip_before_filter :login_required, :saas_filter_for_before,:only=>[:new, :create, :activate]
  before_filter :load_permissions, :only => [:new, :edit]
  # GET /roles
  # GET /roles.xml
  def index
    submenu_item 'role-index'
    @roles = Role.paginate_by_sql("select t1.role_id id,t3.role_name,t3.description from
    (select a1.role_id,count(*) permission_num from roles_permissions a1
    where a1.permission_id in (select permission_id from roles_permissions where role_id =#{@current_user.role_id})
    group by a1.role_id) t1,
    (select role_id,count(*) permission_num from roles_permissions where role_id > 1 group by role_id) t2,
    roles t3
    where t1.permission_num = t2.permission_num and t1.role_id = t2.role_id
    and t1.role_id = t3.id ",:page => params[:page], :per_page => 30)

  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    submenu_item 'role-new'
    @role = Role.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/1/edit
  def edit
    submenu_item 'role-index'
    @role = Role.find(params[:id])
    @selected_permissions = {}
    @selected_modules = {}
    @selected_name ={}
    @role.permissions.each do |p|
      @selected_modules[p.module_name] = "checked"
      @selected_name[p.name] = "checked"
      @selected_permissions[p.id] = "checked"
    end

    respond_to do |format|
      format.html #edit.html.erb
      format.xml {render :xml => @role}
    end
  end

  # POST /roles
  # POST /roles.xml
  def create
    submenu_item 'role_new'
    load_permissions
    ids=params[:permissions].select{|k,v| v=='1'}.map { |k,v| k.to_i } unless params[:permissions].nil?
    if ids.length > 0
      permissions=Permission.find(:all, :conditions => ["id in (#{ids.join(',')})"])
      params[:role][:permissions] = permissions
      @role = Role.new(params[:role])
      if @role.save
        flash[:notice] = "创建角色成功"
        redirect_to :action => 'index'
      else
        flash[:error] = "创建角色失败"
        render :action => 'new'
      end
    else
      flash[:error] = "角色名或权限不能为空"
      redirect_to :action => 'new'
    end

  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    load_permissions
    ids = params[:permissions].select {|k, v|  v == "1"}.map {|k,v| k.to_i }
    if ids.length > 0
      permissions = Permission.find(:all, :conditions => ["id in (#{ids.join(',')})"])
      @role = Role.find(params[:id])
      params[:role][:permissions] = permissions
      if @role.update_attributes(params[:role])
        flash[:notice] = "修改角色成功"
        redirect_to :action => 'index'
      else
        flash[:error] = '修改角色失败'
        redirect_to :action => 'edit', :id => @role.id
      end
    else
      flash[:error] = "角色名或权限不能为空"
      redirect_to :action => 'edit', :id => @role.id
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    id=params[:id]
    @role = Role.find(params[:id])
    if id.to_a.include?(self.current_user.role_id.to_s)
      flash[:error] = "不能删除自身角色"
      redirect_to :action => 'index'
    elsif  @role.role_name == "admin"
      flash[:error] = "不能删除缺省角色"
      redirect_to :action => 'index'
    elsif @role.destroy
      flash[:notice] = "删除成功"
      redirect_to :action => 'index'
    else
      flash[:error] ="删除失败,该角色正在被引用，请先删除该角色的用户。"
      redirect_to :action => 'index'
    end
  end

  private
  def load_permissions
    @perm_modules = ActiveSupport::OrderedHash.new
    permissions = @current_user.role.permissions
    permissions.each do |px|
      @perm_modules[px.module_name] ||= []
      @perm_modules[px.module_name] << px
    end
    @perm_modules.each do |key,value|
      @perm_name= ActiveSupport::OrderedHash.new
      value.each  do |v|
        @perm_name[v.name] ||= []
        @perm_name[v.name] << v
      end
      @perm_modules[key] = @perm_name
    end
  end

end