require "test_helper"

class ReadingsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get readings_show_url
    assert_response :success
  end

  test "should get new" do
    get readings_new_url
    assert_response :success
  end

  test "should get create" do
    get readings_create_url
    assert_response :success
  end

  test "should get index" do
    get readings_index_url
    assert_response :success
  end

  test "should get destroy" do
    get readings_destroy_url
    assert_response :success
  end
end
