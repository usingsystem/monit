class AgentsController < ApplicationController
  # GET /agents
  # GET /agents.xml
  menu_item 'hosts'
  def index
    submenu_item 'agents-index'

    @agents = Agent.paginate query(:page => params[:page])
    status_tab

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agents }
    end
  end

  # GET /agents/1
  # GET /agents/1.xml
  def show
    @agent = Agent.find(params[:id], query)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agent }
    end
  end

  # GET /agents/new
  # GET /agents/new.xml
  def new
    submenu_item 'agents-new'
    @agent = Agent.new(:host_id => params[:host_id])
    dictionary

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @agent }
    end
  end

  # GET /agents/1/edit
  def edit
    @agent = Agent.find(params[:id])
    dictionary
  end

  # POST /agents
  # POST /agents.xml
  def create
    @agent = Agent.new(params[:agent])
    @agent.tenant_id = current_user.tenant_id

    respond_to do |format|
      if @agent.save
        flash[:notice] = "#{@agent.name}创建成功。"
        Rosteruser.create!([{:username => @agent.username, :jid => "#{current_user.username}@monit.cn", :subscription => "B", :ask => "N", :server => "N", :type => "item"}, {:username => current_user.username, :jid => "#{@agent.username}@agent.monit.cn", :subscription => "B", :ask => "N", :server => "N", :type => "item", :nick => @agent.name}])
        format.html { 
          redirect_to(@agent) 
        }
        format.xml  { render :xml => @agent, :status => :created, :location => @agent }
      else
        dictionary
        format.html { render :action => "new" }
        format.xml  { render :xml => @agent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /agents/1
  # PUT /agents/1.xml
  def update
    @agent = Agent.find(params[:id])
    params.delete :username
    params.delete :name
    params.delete :password

    respond_to do |format|
      if @agent.update_attributes(params[:agent])
        Rosteruser.update_all({:nick => @agent.name}, {:jid => "#{@agent.username}@agent.monit.cn"})
        flash[:notice] = "#{@agent.name}更新成功"
        format.html { redirect_to(@agent) }
        format.xml  { head :ok }
      else
        dictionary
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agent.errors, :status => :unprocessable_entity }
      end
    end
  end

  def confirm
    @agent = Agent.find(params[:id])
  end

  # DELETE /agents/1
  # DELETE /agents/1.xml
  def destroy
    @agent = Agent.find(params[:id])
    flash[:success] = "#{@agent.username}删除成功"
    @agent.destroy

    respond_to do |format|
      format.html { redirect_to(agents_url) }
      format.xml  { head :ok }
    end
  end

  private
  def dictionary
    @hosts = Host.all :conditions =>{ :tenant_id => current_user.tenant_id}
  end

  def query options = {}
    order_option options
    con = conditions
    con.update :presence => params[:presence] unless params[:presence].blank?
    options.update({
        :include => ['host'],
        :conditions => con.size == 0 ? nil:con
      })
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
  end

  def status_tab
    stat = Agent.all :select => "presence, count(*) num", :group => "presence", :conditions => conditions
    @status_tab = []
    Agent.presence.each do |s|
      @status_tab.push [s, t('status.agent.' + s), 0, filter_params(params, {:presence => s})]
    end
    n = 0
    stat.each do |s|
      @status_tab[Agent.presence.index(s.presence)][2] = s.num.to_i
      n = n + s.num.to_i
    end
    @status_tab.unshift ['all', t('all'), n, filter_params(params, {:presence => nil})]
    @current_status_name = params[:presence].blank? ? 'all' : params[:presence]
  end

end
