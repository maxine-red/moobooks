require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get permission_denied" do
    get '/403'
    assert_response :forbidden
  end

  test "should get not_found" do
    get '/404'
    assert_response :missing
  end

  test "should get unacceptable" do
    get '/422'
    assert_response :unprocessable_entity
  end

  test "should get internal_error" do
    get '/500'
    assert_response :error
  end

end
