class TenantsController < ApplicationController

  menu_item 'accounts'
  def index
  submenu_item 'tenants'
  redirect_to :action=>:show
  end

  def to_free
    @tenant = current_user.tenant
    @tenant.set_free if @tenant
    redirect_to :back
  end

  def show
    submenu_item 'tenant'
    @tenant = current_user.tenant
    @package = @tenant.package
    @hosts_num = Host.count(:conditions => {:tenant_id => @tenant.id })
    @services_num = Service.count(:conditions => {:tenant_id => @tenant.id })
  end

end
