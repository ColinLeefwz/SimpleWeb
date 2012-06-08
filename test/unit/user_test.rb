require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "add user with a large wb_uid" do
    uid = 2649767991
    user = User.new
    user.wb_uid = uid
    user.password = Digest::SHA1.hexdigest(":dface#{user.wb_uid}")[0,16]
    user.save!
    assert user.wb_uid ==uid
    uid = 2649767991000
    user = User.new
    user.wb_uid = uid
    user.password = Digest::SHA1.hexdigest(":dface#{user.wb_uid}")[0,16]
    user.save!    
  end
end
