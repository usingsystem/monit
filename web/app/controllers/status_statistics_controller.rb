class StatusStatisticsController < ApplicationController

  before_filter :login_required
  menu_item 'reports'
  def index
    submenu_item 'reports-statistics'
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
    @app_status = status_object('app', App, @app_status)
    @site_status = status_object('site', Site, @site_status)
    @device_status = status_object('device', Device, @device_status)
    @service_status = status_object('service', Service, @service_status)

    host_view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%" })
    hosts=Hash.new()
    @host_status.each { |h|
      hosts[h[:title]]=h[:num]
      host_view.items << ViewItem.new(:name => h[:title],:alias=>h[:title], :color=> h[:color])
    }
    @host_view=host_view
    @host_view.data=hosts

    app_view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%"})
    apps=Hash.new()
    @app_status.each { |a|
      apps[a[:title]]=a[:num]
      app_view.items << ViewItem.new(:name => a[:title],:alias=>a[:title], :color=> a[:color])
    }
    @app_view=app_view
    @app_view.data=apps

    service_view=View.new({:template=>"ampie",:enable=>1,:dimensionality=>2,:width=>"80%"})
    services=Hash.new()
    @service_status.each{ |s|
      services[s[:title]]=s[:num]
      service_view.items<< ViewItem.new(:name=>s[:title],:alias=>s[:title],:color=>s[:color])
    }
    @service_view=service_view
    @service_view.data=services

    device_view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%"})
    devices=Hash.new()
    @device_status.each { |d|
      devices[d[:title]]=d[:num]
      device_view.items << ViewItem.new(:name =>d[:title],:alias=>d[:title], :color=> d[:color])
    }
    @device_view=device_view
    @device_view.data=devices


    site_view = View.new({:template => "ampie", :enable => 1, :dimensionality => 2,:width=>"80%"})
    sites=Hash.new()
    @site_status.each { |s|
      sites[s[:title]]=s[:num]
      site_view.items << ViewItem.new(:name =>s[:title],:alias=>s[:title], :color=> s[:color])
    }
    @site_view=site_view
    @site_view.data=sites

  end

   private
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
