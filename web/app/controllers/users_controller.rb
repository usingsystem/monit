class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  menu_item 'accounts'
  include AuthenticatedSystem
  skip_before_filter :login_required, :saas_filter_for_before,:only=>[:new, :create, :activate]
  # render new.rhtml

  def summary
    summaries = Alert.find(:first,:select=>"count(*) num" ,:conditions =>["tenant_id =?", current_user.tenant_id])
    @summaries = summaries.num
    respond_to do |format|
      format.html {render :layput =>false}
    end
  end

  def index
    submenu_item 'user-index'
    @users=User.paginate query(:page=>params[:page])
  end

  def new
    submenu_item 'user-new'
    @user = User.new
    dictionary
#    find_roles
  end


  def edit
    submenu_item 'user-index'
    @user = User.find(params[:id])
    dictionary
#    find_roles
  end

  #  def edit_password
  #    submenu_item 'user-password-edit'
  #    @user = current_user
  #  end

  def create
    submenu_item 'user-new'
    @user=User.new(params[:user])
    @user.tenant_id=current_user.tenant_id
    
    if @user.save
      flash[:notice] = "添加用户成功"
      redirect_to(:action => "index")
    else
#      @roles = Role.find(:all).collect { |c| [c.role_name,c.id]}.uniq
      dictionary
      flash.now[:error]  = "添加用户失败"
      render :action => "new"
    end
  end


  def update
    submenu_item 'user-index'
    @user =User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = '修改成功'
      redirect_to :action => 'edit'
    else
      dictionary
#      @roles = Role.find(:all).collect { |c| [c.role_name,c.id]}.uniq
      flash[:error] = '修改失败'
      render :action => "edit"
    end
  end

  #  def update_password
  #    submenu_item 'user-password-edit'
  #    @user = current_user
  #    if @user.update_password(params[:user])
  #      flash[:notice] = '修改密码成功'
  #      redirect_to :action => 'edit_password'
  #    else
  #      render :action => "edit_password"
  #    end
  #  end

  def destroy
    @user=User.find(params[:id])
    if @user.destroy
      flash[:notice] = "#{@user.name} 删除成功"        
    else
      flash[:error] = "#{@user.name} 删除失败"      
    end
    respond_to do |format|
      format.html { redirect_to(params[:redirect_to]) }
      format.xml  { head :ok }
    end
  end

  def query options={}
    order_option options
    con = conditions
    options.update({
        :conditions => con
      })
  end

  def dictionary
    @groups = Group.all :conditions=>{:tenant_id=>current_user.tenant_id},:order=>:name
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con
  end

  
  def find_roles
    @roles = Role.find_by_sql("select t1.role_id id,t3.role_name from
    (select a1.role_id,count(*) permission_num from roles_permissions a1
    where a1.permission_id in (select permission_id from roles_permissions where role_id =#{@current_user.role_id})
    group by a1.role_id) t1,
    (select role_id,count(*) permission_num from roles_permissions group by role_id) t2,
    roles t3
    where t1.permission_num = t2.permission_num and t1.role_id = t2.role_id
    and t1.role_id = t3.id ").collect { |c|
      if c.role_name == "admin"
        ["系统管理员",c.id]
      else
        [c.role_name,c.id]
      end
    }.uniq
  end


end
