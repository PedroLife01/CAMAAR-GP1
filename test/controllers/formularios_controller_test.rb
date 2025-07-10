require "test_helper"

class FormulariosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get formularios_index_url
    assert_response :success
  end

  test "should get new" do
    get formularios_new_url
    assert_response :success
  end

  test "should get create" do
    get formularios_create_url
    assert_response :success
  end

  test "should get show" do
    get formularios_show_url
    assert_response :success
  end
end
