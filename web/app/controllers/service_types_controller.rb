# To change this template, choose Tools | Templates
# and open the template in the editor.

class ServiceTypesController < AdminController


  def app_host
    if  params[:type]=="2"
      @host_types = AppType.all
    else
      @host_types = HostType.all
    end
    respond_to do |format|
      format.ajax { render :layout => false }
    end
  end

  def index
    @services = ServiceType.paginate query(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end
  def new
    @service = ServiceType.new
    @service.serviceable_type = 1
    @service.ctl_state = 0
    @host_types = HostType.all
  end
  def create
    @service = ServiceType.new(params[:service_type])
    respond_to do |format|
      if @service.save
        flash[:notice] = 'Host was successfully created.'
        format.html { redirect_to(:action=> "new" ) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        @host_types = HostType.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end
  def edit
    @service = ServiceType.find(params[:id])
    if @service.serviceable_type == 1
      @host_types = HostType.all
    else
      @host_types = AppType.all
    end
  end
  def update
    @service = ServiceType.find(params[:id])
    respond_to do |format|
      if @service.update_attributes(params[:service_type])
        flash[:notice] = 'Host was successfully updated.'
        format.html { redirect_to(:action=> "index" ) }
        format.xml  { head :ok }
      else
        if @service.serviceable_type == 1
          @host_types = HostType.all
        else
          @host_types = AppType.all
        end
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def query options = {}
    order_option options
    options.update({
        :select => "service_types.*,case service_types.serviceable_type when 1 then t1.name when 2 then t2.name end source_name,
        case service_types.serviceable_type when 1 then '主机服务' when 2 then '应用服务' end source_type
        ",
        :joins => "left join host_types t1 on t1.id = service_types.serviceable_id and service_types.serviceable_type = 1
                   left join app_types t2 on t2.id = service_types.serviceable_id and service_types.serviceable_type = 2
        "
      })
  end
end
