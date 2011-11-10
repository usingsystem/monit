class TopController < ApplicationController
  menu_item 'reports'
  before_filter :dict

  def index
  end

  def sites
  end

  def hosts
    @host_types = HostType.all
    @host_type ||= @host_types.first
    @service_types = @host_type.service_types_with_view("top")
    render :action => "hosts"
  end

  def apps
  end

  def devices
  end

  def services
    get_sources
  end

  def show
    if params[:service_type_id] and (@service_type = ServiceType.find(params[:service_type_id]))
      service_type
    elsif params[:app_type_id] and (@app_type = AppType.find(params[:app_type_id]))
      apps
    elsif params[:host_type_id] and (@host_type = HostType.find(params[:host_type_id]))
      hosts
    else
    end
  end

  def service_type
    get_sources
    @service_metrics = @service_type.metrics
    @services = @service_type.services.all(:conditions => conditions, :include => @source_type)
    @top = Top.new(@services, @date_range)
    if params[:metric_id] and (@service_metric = @service_metrics.find(params[:metric_id]))
      metric
    else
      @data_view = View.first(:conditions => {:visible_type => "top", :visible_id => @service_type.id, :enable => 1}, :include => ['items'])
      if @data_view
        sort = @data_view.data_params[:sort]
        data = @top.sort(sort, @n)
        @data_view.data = data
        unless params[:format] == "ajax"
          sort = sort.gsub(/^\-/,"")
          @chart_view = View.new(:name => "#{@data_view.name}#{@n_title}", :dimensionality => 3, :enable => 1, :template => "amcolumn", :height => 300, :width => "100%")
          @chart_view.items << ViewItem.new({:name => "#{@source_type}_name", :alias => I18n.t(@source_type), :data_type => "string"})
          item = @data_view.items.select{|x| x.name == sort}.first.dup
          item.color = "33FF00"
          @chart_view.items << item
          @chart_view.data = data
        end
      end

      respond_to do |format|
        format.html {
          render :action => 'service_type'
        }

        format.ajax {
          @data_view.link = service_type_top_path(@service_type, :date => @date) if @data_view
          render :action => 'service_type'
        }

        format.png {
          @chart_view.template = "pltcolumn_stacked"
          @chart_view.height = 300
          @chart_view.width = 600
          render :action => 'metric'
        }
      end
    end
  end

  def metric
    data = @top.sort(@service_metric.name, @n)
    @data_view = View.new(:name => "#{I18n.t(@source_type)}#{@service_metric.desc_without_unit}#{@n_title}", :dimensionality => 3, :enable => 1, :template => "datagrid", :height => 300, :width => "100%")
    @data_view.items << ViewItem.new({:name => "#{@source_type}_name", :alias => I18n.t(@source_type), :data_type => "string", :data_format => "link", :data_format_params => "href=/#{@source_type}s/${#{@source_type}_id}"})
    @data_view.items << ViewItem.new({:name => "service_name", :alias => "服务", :data_type => "string", :data_format => "link", :data_format_params => "href=/services/${service_id}"})
    @data_view.items << ViewItem.new(:name => @service_metric.name, :color => nil, :alias => @service_metric.desc_without_unit, :data_type => @service_metric.metric_type, :data_unit => @service_metric.unit)
    #@service_metrics.each do |metric|
    #  @data_view.items << ViewItem.new(:name => metric.name, :color => nil, :alias => metric.desc_without_unit, :data_type => metric.metric_type, :data_unit => metric.unit)
    #end
    @data_view.data = data

    @chart_view = View.new(:name => "#{I18n.t(@source_type)}#{@service_metric.desc_without_unit}#{@n_title}", :dimensionality => 3, :enable => 1, :template => "amcolumn", :height => 300, :width => "100%")
    @chart_view.items << ViewItem.new({:name => "#{@source_type}_name", :alias => I18n.t(@source_type), :data_type => "string"})
    @chart_view.items << ViewItem.new(:name => @service_metric.name, :color => "33FF00", :alias => @service_metric.desc_without_unit, :data_type => @service_metric.metric_type, :data_unit => @service_metric.unit)
    @chart_view.data = data
    respond_to do |format|
      format.html {
        render :action => 'metric'
      }
      format.png {
        @chart_view.template = "pltcolumn_stacked"
        @chart_view.height = 300
        @chart_view.width = 600
        render :action => 'metric'
      }
    end
  end

  private

  def get_sources
    @source_types = ["host", "app", "site", "device"]
    @source_type = params[:source_type]
    @source_type = @service_type.serviceable_type_name if @service_type
    @source_type = "host" unless @source_types.include?(@source_type)
    @service_types = ServiceType.all(:conditions => {:serviceable_type => ServiceType.serviceable_types.index(@source_type)})
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con
  end

  def dict
    submenu_item 'reports-top'
    @n = params[:n].to_i
    @n = 5 unless @n > 0
    @n = 10 unless @n <= 10
    @n_title = "Top#{@n}"
    d = ['last24hours','today','yesterday','thisweek','last7days','thismonth','last30days']
    @dates = d.collect { |x| [I18n.t(x), x ] }
    @date_range = parse_date_range(params[:date])
    @date = @date_range[:param]
    @human_date = @date_range[:human]
    @tabs = [["site", "网站", sites_top_path],["host", "主机", hosts_top_path],["app", "应用", apps_top_path],["device", "网络", devices_top_path],["service", "服务", services_top_path]]
    @tabs.each do |t|
      t[1] = t[1] + @n_title
    end
  end

end
