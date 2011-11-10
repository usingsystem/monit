require 'test_helper'

class OperatorTest < ActiveSupport::TestCase

  test "recharge" do
    monit=operators(:monit)
    other_operator=Operator.create(:amount=>100,:host=>"www.test.com",:title=>"test标题",:password=>"public123",:password_confirmation=>"public123")
    assert other_operator.bills.blank?
    assert !other_operator.recharge(monit,1000)
    monit.recharge(other_operator,1000)
    assert_equal other_operator.bills.first.amount,1000
    assert_equal other_operator.amount,1100
    monit.recharge(other_operator,1.1)
    assert_equal other_operator.amount,1101.1

  end
  
end
