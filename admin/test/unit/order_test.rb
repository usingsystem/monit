require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "pay by hand" do
    order=orders(:kehao_order)
    assert !order.new_record?
    assert_equal order.status_name,"waiting"
    assert order.out_trade_no
    assert !order.is_paid
    assert_nil order.pay_mode
    assert_equal order.total_fee,2000
    order.pay_by_hand
    assert_equal order.status_name,"paid"
    assert order.is_paid
    assert_equal order.pay_mode,2
  end
end
