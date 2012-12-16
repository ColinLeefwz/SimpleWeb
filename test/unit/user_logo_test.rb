# coding: utf-8
require 'test_helper'

class UserLogoTest < ActiveSupport::TestCase

#真奇怪！当user_logos表中存在下面的数据时，x.save!会返回true，但是却没有写入user_logos表.
#  { "_id" : ObjectId("50cafac8c90d8b7643000001"), "user_id" : ObjectId("50cafac81846da3379eeba5a") }
#  { "_id" : ObjectId("50caf5dcc90d8b5338000003"), "user_id" : ObjectId("50caf5dc1846da3379eeba59") }
#  { "_id" : ObjectId("50caf5dbc90d8b5338000002"), "user_id" : ObjectId("50caf5db1846da3379eeba58") }
  
  
  test "save!" do
    x = UserLogo.new
    assert_equal true, x.new_record?
    assert_equal true, x.save!
    assert_equal x.id, UserLogo.find(x.id).id
  end

end

