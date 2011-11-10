class OrdersController < ApplicationController

  skip_before_filter :login_required, :only=> :notify
  skip_before_filter :verify_authenticity_token, :only => :notify
  menu_item 'accounts'

  # GET /orders
  # GET /orders.xml
  def index
    submenu_item 'orders'
    @orders = Order.paginate(query(:page => params[:page]))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    submenu_item 'orders'
    @order = Order.find(params[:id], query)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # POST /orders/notify
  # 支付成功callback提示

  def notify
    @order = Order.find_by_out_trade_no(params[:out_trade_no])
    if @order
      if @order.valid_sign(params) and ["TRADE_SUCCESS", "TRADE_FINISHED"].include?(params[:trade_status])
        #if true
        logger.info "orders/notify[#{@order.tenant_id}, #{@order.out_trade_no}, #{@order.is_paid}]: Pay Success.(#{params.inspect})"
        @order.pay_from_alipay(params) unless @order.is_paid?
        render :text => 'SUCCESS'
      else
        logger.info "orders/notify[#{@order.tenant_id}, #{@order.out_trade_no}, #{@order.is_paid}]: Invalid.(#{params.inspect})"
        render :text => 'ERROR'
      end
    else
      render :text => 'ERROR'
    end
  end

  #GET /orders/return
  def return
    @order = Order.find_by_out_trade_no(params[:out_trade_no], query)
    if @order
      if @order.valid_sign(params) and ["TRADE_SUCCESS", "TRADE_FINISHED"].include?(params[:trade_status])
        #if true
        logger.info "orders/return[#{@order.tenant_id}, #{@order.out_trade_no}, #{@order.is_paid}]: Pay Success.(#{params.inspect})"
        @order.pay_from_alipay(params) unless @order.is_paid?
        flash[:notice] = "支付成功。"
        redirect_to tenant_url
      else
        logger.info "orders/return[#{@order.tenant_id}, #{@order.out_trade_no}, #{@order.is_paid}]: Invalid.(#{params.inspect})"
        flash[:error] = "该定单验证出错。"
        redirect_to @order
      end
    else
      redirect_to orders_url
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    submenu_item 'orders'
    if params[:package_id].blank?
      redirect_to packages_path and return
    else
      @package = @operator.packages.find(params[:package_id])
    end
    redirect_to packages_path and return if @package.category == 0

    @tenant = current_user.tenant
    @current_package = @tenant.package
    @need_settle = @current_package && @current_package.category != 0 && @current_package.id != @package.id
    @order = Order.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  #def edit
  #  @order = Order.find(params[:id])
  #end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @package = @order.package_id && @operator.packages.find(@order.package_id)
    unless @package
      flash[:error] = "未选择套餐"
      redirect_to :back and return
    end
    unless @order.valid?
      flash[:error] = "不支持该购买期"
      redirect_to :back and return
    end
    @tenant = current_user.tenant
    @current_package = @tenant.package
    need_charge = @package.charge * @order.month_num
    #续费增加
    is_continue = @current_package && @current_package.category != 0 && @current_package.id == @package.id
    unless is_continue
      #结算帐户, 重新预订
      @tenant.order_package(@package.id)
    end
    total_fee = is_continue ? (need_charge - @tenant.clean_balance) : (need_charge - @tenant.balance)
    if total_fee > 0
      @order.total_fee = total_fee
      @order.tenant_id = @tenant.id
      if @order.save
        flash[:notice] = "套餐预订成功。"
        redirect_to(@order)
      else
        redirect_to :back
      end
    else
      @tenant.handle_package(@package.id, @order.month_num)
      flash[:notice] = "套餐更新成功。"
      redirect_to tenant_url
    end

    #respond_to do |format|
    #  if @order.save
    #    flash[:notice] = 'Order was successfully created.'
    #    format.html { redirect_to(@order) }
    #    format.xml  { render :xml => @order, :status => :created, :location => @order }
    #  else
    #    format.html { render :action => "new" }
    #    format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  #def update
  #  @order = Order.find(params[:id])

  #  respond_to do |format|
  #    if @order.update_attributes(params[:order])
  #      flash[:notice] = 'Order was successfully updated.'
  #      format.html { redirect_to(@order) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  ## DELETE /orders/1
  ## DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id], query)
    @order.cancel

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

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
  end

end
