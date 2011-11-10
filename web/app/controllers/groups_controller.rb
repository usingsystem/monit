# To change this template, choose Tools | Templates
# and open the template in the editor.

class GroupsController  < AdminController
  menu_item 'accounts'
  def index
    submenu_item 'groups'
    @groups = Group.paginate query(:select=>"*",:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

  def new
    submenu_item 'groups_new'
    @group = Group.new
    @parent_groups = Group.all :order=>:name
  end

  def create
    @group = Group.new(params[:group])
    @group.tenant_id = current_user.tenant_id
    respond_to do |format|
      if @group.save
        flash[:notice] = '分组创建成功.'
        format.html { redirect_to(:action=> "index" ) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        submenu_item 'groups_new'
        @parent_groups = Group.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    submenu_item 'groups'
    @group = Group.find(params[:id])
    @parent_groups = Group.all
  end

  def update
    submenu_item 'groups'
    @group = Group.find(params[:id])
    params[:group][:tenant_id]= current_user.tenant_id
    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = '分组修改成功.'
        format.html { redirect_to(:action=> "index" ) }
        format.xml  { head :ok }
      else
        @parent_groups = Group.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.hosts.count<=0 && @group.sites.count<=0 && @group.apps.count<=0 && @group.devices.count<=0 &&  Group.destroy(params[:id])
      flash[:notice] = "#{@group.name} 删除成功"
    else
      flash[:error] = "#{@group.name} 删除失败"
    end
    respond_to do |format|
      format.html { redirect_to(params[:redirect_to]) }
      format.xml  { head :ok }
    end
  end

  def query options = {}
    order_option options
    tenant_id = current_user.tenant_id
    options.update({
        :select => "groups.*,0 web_num ,0 host_num ,0 app_num ,0 net_num ,0 server_num,t1.name parent_name
        ",
        :joins => "left join groups t1 on t1.id = groups.parent_id",
        :conditions => " groups.tenant_id = #{tenant_id}",
        :order=>"name"
      })
  end
end
