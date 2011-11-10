class ViewsController < ApplicationController
  # GET /views
  # GET /views.xml
  def index

    @views = View.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @views }
    end

  end

  # GET /views/1
  # GET /views/1.xml
  def show
    @service = Service.find(params[:service_id], :conditions => conditions)
    @metric = @service.metric
    #now = Time.now
    now = Time.parse("2010-6-10 12:00") #for test
    d = @metric.history({:start => now - 24*60*60, :finish => now})
    #if d.size > 0
    #  @history_views = @metric.history_views
    #  @history_views.each do |view|
    #    view.data = d
    #  end
    #end
    @data = d
    @view = View.find(params[:id], {:include => ["items"]})
    @view.data = d



    respond_to do |format|
      format.html #show.html.erb
      format.png #show.gruff
      format.xml  { render :xml => @view }
    end
  end

  def data

    @service = Service.find(params[:service_id], :conditions => conditions)
    @metric = @service.metric
    now = Time.now
    #now = Time.parse("2010-6-10 12:00") #for test
    d = @metric.history({:start => now - 24*60*60, :finish => now})
    @view = View.find(params[:id], {:include => ["items"]})
    @view.data = d

    respond_to do |format|
      format.html # index.html.erb

      format.csv {
        @view.normalize_data
        @view.format_data
        @view.filter_data
        send_data(@view.rows.to_s("\n",";"), :type => 'text/csv; header=present', :filename => 'data.csv')
        #send_data(@view.rows.to_s("\n",";"))
      }
    end
  end
  # GET /views/new
  # GET /views/new.xml
  def new
    @view = View.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @view }
    end
  end

  # GET /views/1/edit
  def edit
    @view = View.find(params[:id])
  end

  # POST /views
  # POST /views.xml
  def create
    @view = View.new(params[:view])

    respond_to do |format|
      if @view.save
        flash[:notice] = 'View was successfully created.'
        format.html { redirect_to(@view) }
        format.xml  { render :xml => @view, :status => :created, :location => @view }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @view.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /views/1
  # PUT /views/1.xml
  def update
    @view = View.find(params[:id])

    respond_to do |format|
      if @view.update_attributes(params[:view])
        flash[:notice] = 'View was successfully updated.'
        format.html { redirect_to(@view) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @view.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /views/1
  # DELETE /views/1.xml
  def destroy
    @view = View.find(params[:id])
    @view.destroy

    respond_to do |format|
      format.html { redirect_to(views_url) }
      format.xml  { head :ok }
    end
  end

  private

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
  end

end
