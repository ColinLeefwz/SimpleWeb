# coding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test ".find2 find 不存在的id返回nil" do
    assert_equal User.find_by_id('12345'), nil
  end

  test ".find2 find 存在的id 能正确的查询" do
    assert_equal User.find_by_id("502e6303421aa918ba00007c").name, '袁乐天'
  end

  test ".follows_s 没有关注的人" do
    assert_equal User.find_by_id('502e6303421aa918ba000007').follows_s , []
  end

  test ".follows_s 有关注的人" do
    user = User.find_by_id('502e6303421aa918ba00007c')
    foll = [User.find_by_id('502e6303421aa918ba000002').id]
    assert_equal user.follows_s , foll
  end

  test ".reports_s 没有举报的人" do
    user = User.find_by_id('502e6303421aa918ba00007c')
    assert_equal user.reports_s , []
  end

  test ".reports_s 有举报的人" do
    user = User.find_by_id('502e6303421aa918ba000007')
    repo = [User.find_by_id('502e6303421aa918ba000002').id]
    assert_equal user.reports_s.map{|m| m['id']} , repo
  end

  test ".black? 用户在黑名单中" do
    user = User.find_by_id('502e6303421aa918ba000007')
    blackuser  = User.find_by_id('502e6303421aa918ba000002')
    assert user.black?(blackuser.id)
  end

  test ".black? 用户不在黑名单中" do
    user = User.find_by_id('502e6303421aa918ba000002')
    blackuser  = User.find_by_id('502e6303421aa918ba000007')
    assert !user.black?(blackuser.id)

  end

  test ".friend? 没有关注的人" do
    user = User.find_by_id('502e6303421aa918ba000007')
    foll = User.find_by_id('502e6303421aa918ba000002')
    assert !user.friend?(foll.id)
  end

  test ".friend? 关注的user中没有特定的一个user" do
    user = User.find_by_id('502e6303421aa918ba00007c')
    foll = User.find_by_id('502e6303421aa918ba000007')
    assert !user.friend?(foll.id)
  end

  test ".friend? 关注的user中存在特定的一个user" do
    user = User.find_by_id('502e6303421aa918ba000002')
    foll = User.find_by_id('502e6303421aa918ba000007')
    assert user.friend?(foll.id)
  end


  test ".follower? 没有被特定的人关注" do
    user = User.find_by_id('502e6303421aa918ba00007c')
    foll = User.find_by_id('502e6303421aa918ba000007')
    assert !user.follower?(foll.id)
  end

  test ".follower? 被特定的人关注了" do
    foll = User.find_by_id('502e6303421aa918ba00007c')
    user = User.find_by_id('502e6303421aa918ba000007')
    assert !user.follower?(foll.id)
  end
  
  test "set/unset的缓存" do
    user = User.find('502e6303421aa918ba00007c')
    user.update_attribute(:job, "it")
    assert_equal user.job, "it"    
    assert_equal User.find('502e6303421aa918ba00007c').job, "it"
    assert_equal User.find_by_id('502e6303421aa918ba00007c').job, "it"
    user.unset(:job)
    assert_equal User.find('502e6303421aa918ba00007c').job, nil
    assert_equal User.find_by_id('502e6303421aa918ba00007c').job, nil
    user.job="it2"
    user.save!
    assert_equal User.find('502e6303421aa918ba00007c').job, "it2"
    assert_equal User.find_by_id('502e6303421aa918ba00007c').job, "it2"    
    
    User.find_by_id('502e6303421aa918ba00007c')
    user = User.find_by_id('502e6303421aa918ba00007c')
    user.update_attribute(:job, "it3")
    assert_equal user.job, "it3"    
  end
  
  
end

