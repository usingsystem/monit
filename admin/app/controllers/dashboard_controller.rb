class DashboardController < ApplicationController
  menu_item 'dashboard'

  def index
    @recent_operators=Operator.all(:limit=>10,:order=>"created_at desc")
    @recent_bills=Bill.by_monit.all :limit=>10,:order=>"created_at desc"
   
  end

  def summary
    summary_tab
 
    respond_to do |format|
      format.html
      format.ajax{ render :layout => false }
    end
  end

  def edit
    submenu_item 'operator-edit'
  end
  
  private
  def summary_tab
    query={:joins=>"inner join tenants as te on tenant_id=te.id",:conditions=>["te.operator_id=?",@operator.id]}
    @tenant_count=@operator.tenants.count
    @site_count=Site.count(query)
    @host_count=Host.count(query)
    @app_count=App.count(query)
    @device_count=Device.count(query)
    @service_count=Service.count(query)
    proc=Proc.new do |a,entry|
      a << {:name=>I18n.t(entry),:count=> instance_variable_get("@#{entry}_count")}
      a
    end
    @summary_tab=[:tenant,:site,:host,:app,:device,:service].inject([],&proc)
  end

end

