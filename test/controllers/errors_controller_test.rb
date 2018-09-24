require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get permission_denied" do
    get errors_permission_denied_url
    assert_response :success
  end

  test "should get not_found" do
    get errors_not_found_url
    assert_response :success
  end

  test "should get unacceptable" do
    get errors_unacceptable_url
    assert_response :success
  end

  test "should get internal_error" do
    get errors_internal_error_url
    assert_response :success
  end

end
