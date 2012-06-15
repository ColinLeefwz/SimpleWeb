require 'test_helper'

class FollowsControllerTest < ActionController::TestCase
  setup do
    @follow = follows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:follows)
  end



  test "should create follow" do
    #assert_difference('Follow.count') do
      post :create, :follow => @follow.attributes
    #end
  end



  test "should destroy follow" do
    assert_difference('Follow.count', -1) do
      delete :destroy, :id => @follow
    end

    assert_redirected_to follows_path
  end
end
