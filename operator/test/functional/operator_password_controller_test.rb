require 'test_helper'

class OperatorPasswordControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper
  def setup
    login_as(operators(:monit))
  end
  test "edit" do
    get :edit
    assert_template :edit
    assert_equal assigns(:submenu_item),'operator-password'
  end

  test "update with current old password" do
    put :update,:operator=>{:old_password=>"public",:password=>"123456",:password_confirmation=>"123456"}
    assert_match /密码修改成功/,flash[:notice]
  end

  test "update with wrong old password" do
    put :update,:operator=>{:old_password=>"123456",:password=>"8888888",:password_confirmation=>"8888888"}
    assert_nil flash[:notice]
    assert_template :edit
  end
  test "update with current old password but wrong password" do
    put :update,:operator=>{:old_password=>"public",:password=>"1",:password_confirmation=>"1"}
    assert_nil flash[:notice]
    assert_template :edit
    put :update,:operator=>{:old_password=>"public",:password=>"123456",:password_confirmation=>"444444"}
    assert_nil flash[:notice]
    assert_template :edit
    put :update,:operator=>{:old_password=>"public",:password=>"",:password_confirmation=>""}
    assert_nil flash[:notice]
    assert_template :edit
  end
end
