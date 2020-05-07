require 'test_helper'

class RestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resto = restos(:one)
  end

  test "should get index" do
    get restos_url
    assert_response :success
  end

  test "should get new" do
    get new_resto_url
    assert_response :success
  end

  test "should create resto" do
    assert_difference('Resto.count') do
      post restos_url, params: { resto: { name: @resto.name } }
    end

    assert_redirected_to resto_url(Resto.last)
  end

  test "should show resto" do
    get resto_url(@resto)
    assert_response :success
  end

  test "should get edit" do
    get edit_resto_url(@resto)
    assert_response :success
  end

  test "should update resto" do
    patch resto_url(@resto), params: { resto: { name: @resto.name } }
    assert_redirected_to resto_url(@resto)
  end

  test "should destroy resto" do
    assert_difference('Resto.count', -1) do
      delete resto_url(@resto)
    end

    assert_redirected_to restos_url
  end
end
