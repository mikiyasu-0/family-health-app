require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to sign in when not logged in" do
    get dashboard_url
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end
end
