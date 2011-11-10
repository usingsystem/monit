require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  test "index" do
    login_as(operators(:monit))
    get :index
    assert_template "index"
  end
end
