module UiHelper
  def filter_params options = {}, update = {}
    options = options.dup
    options.delete :sort
    options.delete :page
    options.delete :action
    options.delete :controller
    options.delete :out_trade_no
    options.update update
    options
  end

end
