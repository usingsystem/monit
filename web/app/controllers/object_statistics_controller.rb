class ObjectStatisticsController < ApplicationController

  before_filter :login_required
   menu_item 'reports'

  def index
    submenu_item 'reports-statistics'
    @host_types=Host.find_by_sql("select h1.name,count(*) count from hosts h ,host_types h1 where h.type_id=h1.id and tenant_id=#{current_user.tenant_id}  group by h.type_id" )
    @app_types=App.find_by_sql("select a1.name,count(*) count from apps a,app_types a1 where a.type_id=a1.id and tenant_id=#{current_user.tenant_id} group by a.type_id")
    @device_types=Device.find_by_sql("select d1.name,count(*) count from devices d,device_types d1 where d.type_id=d1.id and tenant_id=#{current_user.tenant_id} group by d.type_id")

    host_view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%" })
    hosts=Hash.new()
    @host_types.each { |h|
      hosts[h.name]=h.count
      host_view.items << ViewItem.new(:name => h.name,:alias=>h.name, :color=> nil)
    }
    @host_view=host_view
    @host_view.data=hosts

    app_view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%"})
    apps=Hash.new()
    @app_types.each { |a|
      apps[a.name]=a.count
      app_view.items << ViewItem.new(:name => a.name,:alias=>a.name, :color=> nil)
    }
    @app_view=app_view
    @app_view.data=apps

    device_view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%"})
    devices=Hash.new()
    @device_types.each { |d|
      devices[d.name]=d.count
      device_view.items << ViewItem.new(:name =>d.name,:alias=>d.name, :color=> nil)
    }
    @device_view=device_view
    @device_view.data=devices

    object_view= View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%"})
    @objects=Hash.new()
    @objects["主机"]=@host_types.length
    @objects["应用"]=@app_types.length
    @objects["网络"]=@device_types.length
    @objects.each {|k,v|
      object_view.items << ViewItem.new(:name=>k,:alias=>k,:color=>nil)
    }
    @object_view=object_view
    @object_view.data=@objects

  end


end
