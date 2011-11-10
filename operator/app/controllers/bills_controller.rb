class BillsController < ApplicationController
  menu_item 'bills'
  def index
    submenu_item "bills-tenant"
    sort=parse_sort params[:sort]
    @bills=Bill.order(sort).by_tenant(@operator).paginate :page=>params[:page]
  end

  def operator
    submenu_item "bills-monit"
    sort=parse_sort params[:sort]
    @bills=Bill.order(sort).by_monit(@operator).paginate :page=>params[:page]
  end
end
