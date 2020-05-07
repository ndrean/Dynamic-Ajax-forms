require 'test_helper'

class NestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get nests_new_url
    assert_response :success
  end

  test "should get create" do
    get nests_create_url
    assert_response :success
  end

end
