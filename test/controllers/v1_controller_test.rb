require 'test_helper'

class V1ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_index_url
    assert_response :success
  end

end
