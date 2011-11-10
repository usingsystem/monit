require 'test_helper'

class OperatorsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  test "edit" do
    login_as(operators(:monit))
    get :edit,:id=>operators(:monit)
    assert_equal  assigns(:submenu_item),"operator-edit"
    assert_response :success
  end

#  test "new" do
#    get :new ,:code=>Operator::RegistPassword
#    assert_response :success
#    assert_template :new
#  end

  test "new without code" do
    get :new
    assert_response :success
    assert_match /注册请联系我们！/, @response.body
  end

  test "create" do
    assert_difference 'Operator.count',1 do
      post :create,:operator=>{:title=>"test",:host=>"www.test.com",:password=>"test123",:password_confirmation=>"test123"},
        :code=>Operator::RegistPassword
      assert_not_nil	assigns(:operator)
      assert	!assigns(:operator).new_record?
      assert_redirected_to(:controller => "dashboard")
    end
  end

test "create without code" do
    assert_difference 'Operator.count',0 do
      post :create,:operator=>{:title=>"test",:host=>"www.test.com",:password=>"test123",:password_confirmation=>"test123"}
      assert_nil	assigns(:operator)
      assert_response :success
      assert_match /注册请联系我们！/, @response.body
    end
  end


  test "should update user" do
    login_as(operators(:monit))
    put	:update,:operator=>{:descr=>"test descr"}
    assert_response :redirect
    assert_equal assigns(:operator).descr,"test descr"
		assert_not_nil	assigns(:operator)
		assert_not_nil	assigns(:current_user)
		assert_equal assigns(:current_user),assigns(:operator)
  end
end
