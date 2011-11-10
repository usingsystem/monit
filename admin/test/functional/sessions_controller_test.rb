require File.dirname(__FILE__) + '/../test_helper'

class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase
 
  include AuthenticatedTestHelper

  test "should login and redirect" do
    post :create, :host => operators(:monit).host, :password => 'public'
    assert session[:user_id]
    assert_response :redirect
    assert ls=LogmSecurity.find_by_user(assigns(:operator).id)
    assert_equal ls.security_cause,"成功登入."
    assert_equal session[:login],assigns(:operator).host

  end

  test "should fail login and not redirect" do
    post :create, :host => operators(:monit).host, :password => 'bad password'
    assert_nil session[:user_id]
    assert_response :success
    assert ls=LogmSecurity.find_by_user(assigns(:operator).id)
    assert_equal ls.result,'失败'

  end
 
    def test_should_logout
      login_as :monit
      get :destroy
      assert_nil session[:user_id]
      assert_response :redirect
    end
  
    def test_should_remember_me
      @request.cookies["auth_token"] = nil
      post :create, :host => operators(:monit).host, :password => 'public', :remember_me => "1"
      assert_not_nil @response.cookies["auth_token"]
    end
  
    def test_should_not_remember_me
      @request.cookies["auth_token"] = nil
      post :create, :host => operators(:monit).host, :password => 'public', :remember_me => "0"
      assert @response.cookies["auth_token"].blank?
    end
  
    def test_should_delete_token_on_logout
      login_as operators(:monit)
      get :destroy
      assert @response.cookies["auth_token"].blank?
    end
  
    def test_should_login_with_cookie
      operators(:monit).remember_me
      @request.cookies["auth_token"] = cookie_for(:monit)
      get :new
      assert @controller.send(:logged_in?)
    end
  
    def test_should_fail_expired_cookie_login
      operators(:monit).remember_me
      operators(:monit).update_attribute :remember_token_expires_at, 5.minutes.ago
      @request.cookies["auth_token"] = cookie_for(:monit)
      get :new
      assert !@controller.send(:logged_in?)
    end
  
    def test_should_fail_cookie_login
      operators(:monit).remember_me
      @request.cookies["auth_token"] = auth_token('invalid_auth_token')
      get :new
      assert !@controller.send(:logged_in?)
    end

  protected
  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token operators(user).remember_token
  end
end
