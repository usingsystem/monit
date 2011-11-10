class BillsController < ApplicationController
  menu_item 'bills'
  def index
     sort=parse_sort params[:sort]
    @bills=Bill.order(sort).by_monit.paginate :page=>params[:page]
  end

end
