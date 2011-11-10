class BillsController < ApplicationController
  # GET /bills
  # GET /bills.xml
  menu_item 'accounts'
  def index
    submenu_item 'bills'
    @bills = Bill.paginate query(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end

  ## GET /bills/1
  ## GET /bills/1.xml
  #def show
  #  @bill = Bill.find(params[:id])

  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @bill }
  #  end
  #end

  ## GET /bills/new
  ## GET /bills/new.xml
  #def new
  #  @bill = Bill.new

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @bill }
  #  end
  #end

  ## GET /bills/1/edit
  #def edit
  #  @bill = Bill.find(params[:id])
  #end

  ## POST /bills
  ## POST /bills.xml
  #def create
  #  @bill = Bill.new(params[:bill])

  #  respond_to do |format|
  #    if @bill.save
  #      flash[:notice] = 'Bill was successfully created.'
  #      format.html { redirect_to(@bill) }
  #      format.xml  { render :xml => @bill, :status => :created, :location => @bill }
  #    else
  #      format.html { render :action => "new" }
  #      format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  ## PUT /bills/1
  ## PUT /bills/1.xml
  #def update
  #  @bill = Bill.find(params[:id])

  #  respond_to do |format|
  #    if @bill.update_attributes(params[:bill])
  #      flash[:notice] = 'Bill was successfully updated.'
  #      format.html { redirect_to(@bill) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  ## DELETE /bills/1
  ## DELETE /bills/1.xml
  #def destroy
  #  @bill = Bill.find(params[:id])
  #  @bill.destroy

  #  respond_to do |format|
  #    format.html { redirect_to(bills_url) }
  #    format.xml  { head :ok }
  #  end
  #end

  private

  def query options = {}
    order_option options
    con = conditions
    options.update({
      :conditions => con
    })
  end

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
    con.update :type_id => 0
  end

end