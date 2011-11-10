require 'test_helper'

class OperatorTest < ActiveSupport::TestCase

  test "should create default packages when create operator" do
    #TODO 
    test=Operator.new(:host=>"www.test.cn",:password=>"public123",:password_confirmation=>"public123",:title=>"test")
    assert test.packages.blank?
    test.save
    #    assert !test.packages.blank?
    #    assert_equal test.packages.size,9
  end

  test "update password" do
    monit=operators(:monit)
    monit.update_password("","new right","new right")
    assert_match /不能为空/,monit.errors[:old_password]
    
    monit.errors.clear
    monit.update_password("wrong","new right","new right")
    assert_match /有误/,monit.errors[:old_password]

    monit.errors.clear
    monit.update_password("public","","")
    assert_match /不能为空/,monit.errors[:password]

    monit.errors.clear
    monit.update_password("public","new right","new_wrong")
    assert monit.errors.invalid?(:password)

    monit.errors.clear
    monit.update_password("public","new right","new right")
    assert monit.valid?
    
  end
end
