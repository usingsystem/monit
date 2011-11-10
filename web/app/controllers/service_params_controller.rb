# To change this template, choose Tools | Templates
# and open the template in the editor.

class ServiceParamsController  < AdminController

  def index
    @services = ServiceParam.paginate query(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end
  def new
    @service = ServiceParam.new
    @service.param_type = 1
    @service.unit = 'int'
    @service_types = ServiceType.all
  end
  def create
    @service = ServiceParam.new(params[:service_param])
    respond_to do |format|
      if @service.save
        flash[:notice] = 'Host was successfully created.'
        format.html { redirect_to(:action=> "new" ) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        @service_types = ServiceType.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end
  def edit
    @service = ServiceParam.find(params[:id])
    @service_types = ServiceType.all
  end
  def update
    @service = ServiceParam.find(params[:id])
    respond_to do |format|
      if @service.update_attributes(params[:service_param])
        flash[:notice] = 'Host was successfully updated.'
        format.html { redirect_to(:action=> "index" ) }
        format.xml  { head :ok }
      else
        @service_types = ServiceType.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def query options = {}
    order_option options
    options.update({
        :select => "service_params.*,
        case service_params.param_type when 1 then '绝对值' when 2 then '相对值变量' end source_type,t1.alias source_name
        ",
        :joins => "left join service_types t1 on t1.id = service_params.type_id
                   
        "
      })
  end
end


