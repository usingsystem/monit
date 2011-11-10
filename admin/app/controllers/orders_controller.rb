class OrdersController < ApplicationController
    menu_item 'orders'

  def index
  sort=parse_sort params[:sort]
  status=parse_status params[:status]
  otn=params[:out_trade_no]
  @orders= Order.order(sort).status(status).join_tenant(@operator).out_trade_no_like(otn).paginate :select=>"orders.*,te.name as tenant_name",:page=>params[:page]
    status_tab do |source|
    source.join_tenant(@operator).all :select => "orders.status, count(*) num", :group => "orders.status"
   end
  end

  def pay
    @order=Order.find(params[:id])
    if @order.pay_by_hand
      flash[:notice]="订单#{@order.out_trade_no}支付成功，服务已生效。"
      redirect_to :action => "index"
    else
      raise "Error: paid by hand fail ! Message was: #{$!.message}"
    end
  end

private
def parse_status(status)
  Order.status.index(status)
end

end
