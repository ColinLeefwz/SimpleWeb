require 'test_helper'

class UserInfoControllerTest < ActionController::TestCase
  test "should get get" do
    get :get
    assert_response :success
  end

  test "should get set" do
    get :set
    assert_response :success
  end

end
