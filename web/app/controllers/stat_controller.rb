class StatController < ApplicationController

  menu_item 'reports'

  def index
    submenu_item 'reports-statistics'
    tabs
    @host_types=Host.find_by_sql("select h1.name,count(*) count from hosts h ,host_types h1 where h.type_id=h1.id and tenant_id=#{current_user.tenant_id}  group by h.type_id" )
    @app_types=App.find_by_sql("select a1.name,count(*) count from apps a,app_types a1 where a.type_id=a1.id and tenant_id=#{current_user.tenant_id} group by a.type_id")
    @device_types=Device.find_by_sql("select d1.name,count(*) count from devices d,device_types d1 where d.type_id=d1.id and tenant_id=#{current_user.tenant_id} group by d.type_id")
    host_count=0
    app_count=0
    device_count=0
    if @host_types
      @host_types.each{|h|
        host_count+=h.count.to_i
      }
      dictionary(@host_types)
      @host_view=@view
      @host_view.data=@hash
    end
    if @app_types
      @app_types.each{|a|
        app_count+=a.count.to_i
      }
      dictionary(@app_types)
      @app_view=@view
      @app_view.data=@hash
    end
    if @device_types
      @device_types.each{|d|
        device_count+=d.count.to_i
      }
      dictionary(@device_types)
      @device_view=@view
      @device_view.data=@hash
    end
    object_view= View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%"})
    @objects=Hash.new()
    @objects["主机"]=host_count
    @objects["应用"]=app_count
    @objects["网络"]=device_count
    @objects.each {|k,v|
      object_view.items << ViewItem.new(:name=>k,:alias=>k,:color=>nil)
    }
    @object_view=object_view
    @object_view.data=@objects
  end

  def status
    submenu_item 'reports-statistics'
    tabs
    q = {
      :select => "status, count(*) num",
      :group => "status",
      :conditions => {:tenant_id =>current_user.tenant_id}
    }
    @host_status = Host.all(q)
    @app_status = App.all(q)
    @service_status = Service.all(q)
    @site_status = Site.all(q)
    @device_status = Device.all(q)

    @host_status = status_object('host', Host, @host_status)
    dictionary1(@host_status)
    @host_view=@view
    @host_view.data=@hash

    @app_status = status_object('app', App, @app_status)
    dictionary1(@app_status)
    @app_view=@view
    @app_view.data=@hash

    @site_status = status_object('site', Site, @site_status)
    dictionary1(@site_status)
    @site_view=@view
    @site_view.data=@hash

    @device_status = status_object('device', Device, @device_status)
    dictionary1(@device_status)
    @device_view=@view
    @device_view.data=@hash

    @service_status = status_object('service', Service, @service_status)
    dictionary1(@service_status)
    @service_view=@view
    @service_view.data=@hash

  end

  def services
    submenu_item 'reports-statistics'
    tabs
    @service_types=Service.find_by_sql("select s1.alias name,count(*) count from services s,service_types s1 where s.type_id=s1.id and tenant_id=#{current_user.tenant_id} group by s.type_id")
    dictionary(@service_types)
    @service_view=@view
    @service_view.data=@hash
  end

  def tabs
    @tabs =[["stat", "资源统计报告", {:controller=>"stat"}], ["status", "状态统计报告", status_stat_path], ["services", " 服务统计报告", services_stat_path]]
  end

  def dictionary object_types
    @view=View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%",:height=>"100%"})
    @hash=Hash.new()
    object_types.each{|d|
      @hash[d.name]=d.count
      @view.items << ViewItem.new(:name =>d.name,:alias=>d.name, :color=> nil)
    }
  end

  def dictionary1 object_status
    @view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%",:height=>"100%" })
    @hash=Hash.new()
    object_status.each { |h|
      @hash[h[:title]]=h[:num]
      @view.items << ViewItem.new(:name => h[:title],:alias=>h[:title],:color=> h[:color])
    }
  end

  def status_object name, model, status
    status = status.to_hash { |s| [s.status, s.num.to_i] }
    i = -1
    model.status.collect do |x|
      i = i + 1
      {
        :id => i,
        :name => x,
        :color => model.status_colors[i],
        :title => I18n.t("status.#{name}.#{x}"),
        :num => status[i] || 0
      }
    end
  end


end
