require 'test_helper'
#

class FollowInfoControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :follows
  fixtures :users


  test "followers" do
    user = User.find_by_id(2)
    get :followers, :id => 1
    assert_equal [user], assigns["users"]
  end

  test "friends" do
    user = User.find_by_id(2)
    get :friends, :id => 1
    assert_equal [user], assigns["users"]
  end
end
