class ServiceStatisticsController < ApplicationController

  before_filter :login_required
  menu_item "reports"

  def index
    submenu_item 'reports-statistics'
    @service_types=Service.find_by_sql("select s1.alias name,count(*) count from services s,service_types s1 where s.type_id=s1.id and tenant_id=#{current_user.tenant_id} group by s.type_id")
#    @site_service=service(3)
#    @host_service=service(1)
#    @app_service=service(2)
#    @device_servie=service(4)
#
#    site_view=View.new({:template=>"ampie",:enable=>1,:dimensionality=>2,:width=>"90%"})
#    sites=Hash.new()
#    @site_service.each{ |s|
#      sites[s.name]=s.count
#      site_view.items<< ViewItem.new(:name=>s.name,:alias=>s.name,:color=>nil)
#    }
#    @site_view=site_view
#    @site_view.data=sites

    service_view=View.new({:template=>"ampie",:enable=>1,:dimensionality=>2,:width=>"80%",:height=>"600"})
    services=Hash.new()
    @service_types.each{ |s|
      services[s.name]=s.count
      service_view.items<< ViewItem.new(:name=>s.name,:alias=>s.name,:color=>nil)
    }
    @service_view=service_view
    @service_view.data=services

  end

  def service(type)
     Service.find_by_sql("select s1.alias name,count(*) count from services s,service_types s1 where s.type_id=s1.id and s.serviceable_type=#{type} and tenant_id=#{current_user.tenant_id} group by s.type_id")
  end

end
