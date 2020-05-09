require 'test_helper'

class GenresControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get genres_new_url
    assert_response :success
  end

  test "should get create" do
    get genres_create_url
    assert_response :success
  end

  test "should get delete" do
    get genres_delete_url
    assert_response :success
  end

end
