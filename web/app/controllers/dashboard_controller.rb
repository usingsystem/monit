class DashboardController < ApplicationController
  menu_item 'dashboard'

  def index
    submenu_item 'dashboard-index'
    @tenant = current_user.tenant
    @package = @tenant.package
    tenant_id = current_user.tenant_id

    @alerts = Alert.all({
      :conditions => {:tenant_id => tenant_id},
      :include => ['service'] + Alert.source_names,
      :limit => 10,
      :order => "changed_at desc"
    })

    @disco_services = DiscoService.all(:limit => 10, :include => ['type'] + DiscoService.serviceable_names, :conditions => ["disco_services.tenant_id = ? and not exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params)", tenant_id])
    q = {
      :select => "status, count(*) num", 
      :group => "status", 
      :conditions => {:tenant_id => tenant_id}
    }
    @host_count = @app_count = @service_count = @site_count = @device_count = 0
    @host_status = Host.all(q)
    @app_status = App.all(q)
    @service_status = Service.all(q)
    @site_status = Site.all(q)
    @device_status = Device.all(q)

    @host_status.each { |x| @host_count = @host_count + x.num.to_i }
    @app_status.each { |x| @app_count = @app_count + x.num.to_i }
    @service_status.each { |x| @service_count = @service_count + x.num.to_i }
    @site_status.each { |x| @site_count = @site_count + x.num.to_i }
    @device_status.each { |x| @device_count = @device_count + x.num.to_i }

    @host_status = status_object('host', Host, @host_status)
    @app_status = status_object('app', App, @app_status)
    @site_status = status_object('site', Site, @site_status)
    @device_status = status_object('device', Device, @device_status)
    @service_status = status_object('service', Service, @service_status)
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
