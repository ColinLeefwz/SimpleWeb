require 'test_helper'

class BlacklistsControllerTest < ActionController::TestCase
  setup do
    @blacklist = blacklists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blacklists)
  end


  test "should destroy blacklist" do
    assert_difference('Blacklist.count', -1) do
      delete :destroy, :id => @blacklist
    end

    assert_redirected_to blacklists_path
  end
end
