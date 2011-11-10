require 'test_helper'

class TenantsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  test "index" do
    login_as(operators(:monit))
    get :index
    assert_response :success
  end
end
