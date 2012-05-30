require 'test_helper'

class AroundmeControllerTest < ActionController::TestCase
  test "should get shops" do
    get :shops
    assert_response :success
  end

  test "should get users" do
    get :users
    assert_response :success
  end

end
