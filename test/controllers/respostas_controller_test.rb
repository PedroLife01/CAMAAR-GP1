require "test_helper"

class RespostasControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get respostas_create_url
    assert_response :success
  end
end
