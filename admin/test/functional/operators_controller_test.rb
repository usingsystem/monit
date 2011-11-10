require 'test_helper'

class OperatorsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  test "recharge" do
    monit=operators(:monit)
    login_as(monit)
    other_operator=Operator.create(:amount=>100,:host=>"www.test.com",:title=>"test标题",:password=>"public123",:password_confirmation=>"public123")
    get :recharge,:id=>other_operator
    assert_template :recharge
    post :recharge,:id=>other_operator,:bill=>{:amount=>1000}
    assert flash[:notice]
    assert !assigns(:bill).new_record?
    assert_template :recharge

    post :recharge,:id=>other_operator,:bill=>{:amount=>"rrrrr"}
    assert assigns(:bill).new_record?
    assert_template :recharge
    assert assigns(:bill).errors.invalid?(:amount)
    post :recharge,:id=>other_operator,:bill=>{:amount=>0}
    assert assigns(:bill).new_record?
    assert_template :recharge
    assert assigns(:bill).errors.invalid?(:amount)
    post :recharge,:id=>other_operator,:bill=>{:amount=>-11}
    assert assigns(:bill).new_record?
    assert_template :recharge
    assert assigns(:bill).errors.invalid?(:amount)
  end
end
