# coding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    reload('user_blacks.js')
    reload('users.js')
    reload('user_follows.js')    
    $redis.keys("Fan*").each {|key| $redis.zremrangebyrank(key,0,-1)}
    $redis.keys("Frd*").each {|key| $redis.zremrangebyrank(key,0,-1)}
    $redis.keys("Fol*").each {|key| $redis.zremrangebyrank(key,0,-1)}
    $redis.keys("BLACK*").each {|key| $redis.zremrangebyrank(key,0,-1)}
    UserFollow.init_fans_redis
    UserFollow.init_good_friend_redis
    UserFollow.init_follows_redis
    UserBlack.init_black_redis
  end



  test ".find2 find 不存在的id返回nil" do
    assert_equal User.find_by_id('12345'), nil
  end

  test ".find2 find 存在的id 能正确的查询" do
    assert_equal User.find_by_id("502e6303421aa918ba00007c").name, '袁乐天'
  end

  test ".follows 没有关注的人" do
    assert_equal User.find_by_id('502e6303421aa918ba000007').follows , []
  end

  test ".follows 有关注的人" do
    user = User.find_by_id('502e6303421aa918ba00007c')
    foll = [User.find_by_id('502e6303421aa918ba000002').id.to_s]
    assert_equal user.follows , foll
  end

  test ".reports_s 没有举报的人" do
    user = User.find_by_id('502e6303421aa918ba00007c')
    assert_equal user.reports_s , []
  end

  test ".reports_s 有举报的人" do
    user = User.find_by_id('502e6303421aa918ba000007')
    assert_equal user.reports_s.map{|m| m.bid.to_s} , ['502e6303421aa918ba000002']
  end

  test ".black? 用户在黑名单中" do
    user = User.find_by_id('502e6303421aa918ba000007')
    blackuser  = User.find_by_id('502e6303421aa918ba000002')
    assert user.black?(blackuser.id)
  end

  test ".black? 用户不在黑名单中" do
    user = User.find_by_id('502e6303421aa918ba000002')
    blackuser  = User.find_by_id('502e6303421aa918ba000007')
    assert_equal user.black?(blackuser.id), false

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


  test ".fan? 没有被特定的人关注" do
    user = User.find_by_id('502e6303421aa918ba00007c')
    foll = User.find_by_id('502e6303421aa918ba000007')
    assert !user.fan?(foll.id)
  end

  test ".fan? 被特定的人关注了" do
    foll = User.find_by_id('502e6303421aa918ba00007c')
    user = User.find_by_id('502e6303421aa918ba000007')
    assert !user.fan?(foll.id)
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

  test "添加删除好友的缓存" do  
  
  end
  
  
end

