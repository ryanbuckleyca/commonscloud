require 'test_helper'

class ConnectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get connections_create_url
    assert_response :success
  end

  test "should get update" do
    get connections_update_url
    assert_response :success
  end

end
