# To change this template, choose Tools | Templates
# and open the template in the editor.

class HostTypesController < AdminController

  def index
    @services = HostType.paginate query(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end
  def new
    @host_type = HostType.new
    @host_types = HostType.all
  end
  def create
    @host_type = HostType.new(params[:host_type])
    @host_type.name = HostType.find(@host_type.parent_id).name+'/'+@host_type.name unless @host_type.parent_id.blank?
    respond_to do |format|
      if @host_type.save
        flash[:notice] = 'Host was successfully created.'
        format.html { redirect_to(:action=> "new" ) }
        format.xml  { render :xml => @host_type, :status => :created, :location => @host_type }
      else
        @host_types = HostType.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @host_type.errors, :status => :unprocessable_entity }
      end
    end
  end
  def edit
    @host_type = HostType.find(params[:id])
    @host_type.name =  @host_type.name.split('/').last
    @host_types = HostType.all
  end
  def update
    @host_type = HostType.find(params[:id])
    params[:host_type][:name] = HostType.find(params[:host_type][:parent_id]).name+'/'+params[:host_type][:name] unless params[:host_type][:parent_id].blank?
    respond_to do |format|
      if @host_type.update_attributes(params[:host_type])
        flash[:notice] = 'Host was successfully updated.'
        format.html { redirect_to(:action=> "index" ) }
        format.xml  { head :ok }
      else
        @host_types = HostType.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @host_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def query options = {}
    order_option options
    options.update({
        :select => "host_types.*,t1.name parent_name
        ",
        :joins => "left join host_types t1 on t1.id = host_types.parent_id"
        
      })
  end
end


