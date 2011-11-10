require 'test_helper'

class LogmSecuritiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:logm_securities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create logm_security" do
    assert_difference('LogmSecurity.count') do
      post :create, :logm_security => { }
    end

    assert_redirected_to logm_security_path(assigns(:logm_security))
  end

  test "should show logm_security" do
    get :show, :id => logm_securities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => logm_securities(:one).to_param
    assert_response :success
  end

  test "should update logm_security" do
    put :update, :id => logm_securities(:one).to_param, :logm_security => { }
    assert_redirected_to logm_security_path(assigns(:logm_security))
  end

  test "should destroy logm_security" do
    assert_difference('LogmSecurity.count', -1) do
      delete :destroy, :id => logm_securities(:one).to_param
    end

    assert_redirected_to logm_securities_path
  end
end
