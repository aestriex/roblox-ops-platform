require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    post user_session_url, params: { user: { email: users(:one).email, password: "password123" } }
    get pages_dashboard_url
    assert_response :success
  end
end
