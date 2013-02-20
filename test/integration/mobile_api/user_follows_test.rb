# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class UserFollowsTest < ActionDispatch::IntegrationTest

  test "添加，删除，查看好友(粉丝)" do
    reload('users.js')

    luser = User.find('502e6303421aa918ba000005')
    user1 = User.find('502e6303421aa918ba00007c')
    user2 = User.find('502e6303421aa918ba000002')

    #登录添加好友
    login(luser.id)
    assert_blank luser.reload.follows_s
    assert !user1.reload.follower?(luser.id)
    post "/follows/create",{:user_id => luser.id, :follow_id => user1.id}
    assert_response :success
    assert luser.reload.friend?(user1.id)
    assert user1.follower?(luser.id)
    assert_equal JSON.parse(response.body), {"saved"=>"502e6303421aa918ba00007c"}

    #未登录添加好友
    logout
    post "/follows/create",{:user_id => luser.id, :follow_id => user2.id}
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal luser.reload.friend?(user2.id), false
    assert_equal user2.follower?(luser.id), false

    #登录添加另一用户的好友
    logout
    login(user1.id)
    post "/follows/create",{:user_id => luser.id, :follow_id => user2.id}
    assert_response :success
    assert_equal response.body, {"error"=>"user 502e6303421aa918ba000005 != session user 502e6303421aa918ba00007c"}.to_json
    assert_equal luser.reload.friend?(user2.id), false
    assert_equal user2.follower?(luser.id), false

    #未登录粉丝列表
    logout
    get "/follow_info/followers?id=#{user1.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert_equal data, [{"name"=>"25","signature"=>"","wb_uid"=>"1644166662","gender"=>0.0,"birthday"=>"","jobtype"=>nil,"pcount"=>0,"id"=>"502e6303421aa918ba000002","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>true,"follower"=>true,"last"=>"隐身"},{"name"=>"袁乐天","signature"=>"","wb_uid"=>"a1","gender"=>1.0,"jobtype"=>nil,"pcount"=>0,"id"=>"502e6303421aa918ba000005","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>false,"follower"=>true,"last"=>""}]

    #登录粉丝列表
    login(luser.id)
    get "/follow_info/followers?id=#{user1.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert_equal data, [{"name"=>"25","signature"=>"","wb_uid"=>"1644166662","gender"=>0.0,"birthday"=>"","jobtype"=>nil,"pcount"=>0,"id"=>"502e6303421aa918ba000002","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>true,"follower"=>true,"last"=>"隐身"},{"name"=>"袁乐天","signature"=>"","wb_uid"=>"a1","gender"=>1.0,"jobtype"=>nil,"pcount"=>0,"id"=>"502e6303421aa918ba000005","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>false,"follower"=>true,"last"=>""}]

    #未登录好友列表
    logout
    get "/follow_info/friends?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert_equal data, [{"name"=>"袁乐天","signature"=>"","wb_uid"=>"a1","gender"=>1.0,"birthday"=>"","jobtype"=>nil,"pcount"=>0,"id"=>"502e6303421aa918ba00007c","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>true,"follower"=>false,"last"=>"10+ days 测试1"}]

    #登录好友列表
    login(luser.id)
    get "/follow_info/friends?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert_equal data, [{"name"=>"袁乐天","signature"=>"","wb_uid"=>"a1","gender"=>1.0,"birthday"=>"","jobtype"=>nil,"pcount"=>0,"id"=>"502e6303421aa918ba00007c","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>true,"follower"=>false,"last"=>"10+ days 测试1"}]

    #登录添加再添加一个好友
    logout
    login(luser.id)
    assert_equal luser.reload.follows_s.count, 1
    assert_equal luser.reload.friend?(user2.id), false
    assert_equal user2.follower?(luser.id), false
    post "/follows/create",{:user_id => luser.id, :follow_id => user2.id}
    assert_response :success
    assert_equal JSON.parse(response.body), {"saved"=>"502e6303421aa918ba000002"}
    assert_equal luser.reload.follows_s.count, 2
    assert_equal luser.reload.friend?(user2.id), true
    assert_equal user2.follower?(luser.id), true

    #未登录删除好友
    logout
    post "follows/delete",{:user_id => luser.id, :follow_id => user1.id }
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal luser.reload.follows_s.count, 2
    assert_equal luser.reload.friend?(user1.id), true
    assert_equal user1.follower?(luser.id), true

    #登录删除好友
    login(luser.id)
    post "follows/delete",{:user_id => luser.id, :follow_id => user1.id }
    assert_response :success
    assert_equal JSON.parse(response.body), {"deleted"=>"502e6303421aa918ba00007c"}
    assert_equal luser.reload.follows_s.count, 1
    assert_equal luser.reload.friend?(user1.id), false
    assert_equal user1.follower?(luser.id), false

    #登录删除另一个用户的好友
    logout
    login(user1.id)
    post "follows/delete",{:user_id => luser.id, :follow_id => user2.id }
    assert_response :success
    assert_equal JSON.parse(response.body),{"error"=>"user 502e6303421aa918ba000005 != session user 502e6303421aa918ba00007c"}
    assert_equal luser.reload.follows_s.count, 1
    assert_equal luser.reload.friend?(user2.id), true
    assert_equal user2.follower?(luser.id), true

    #登录再删除好友
    logout
    login(luser.id)
    post "follows/delete",{:user_id => luser.id, :follow_id => user2.id }
    assert_response :success
    assert_equal JSON.parse(response.body), {"deleted"=> user2.id.to_s}
    assert_equal luser.reload.follows_s.count, 0
    assert_equal luser.reload.friend?(user2.id), false
    assert_equal user2.follower?(luser.id), false
  end



end

