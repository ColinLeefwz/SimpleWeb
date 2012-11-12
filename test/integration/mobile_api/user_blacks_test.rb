# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class UserBlacksTest < ActionDispatch::IntegrationTest

  test "添加，删除，查看黑名单" do
    reload('users.js')
    luser = User.find('502e6303421aa918ba000005')
    user1 = User.find('502e6303421aa918ba00007c')
    user2 = User.find('502e6303421aa918ba000002')

    #登录添加黑名单
    login("502e6303421aa918ba000005")
    assert_blank session_user.blacks_s
    post "/blacklists/create", {:user_id => luser.id, :block_id => user1.id}
    assert_response :success
    assert session_user.blacks_s.detect{|data| data["id"] == user1.id}
    assert_equal luser.reload.blacks_s.count, 1
    assert_equal response.body, {"id"=>"502e6303421aa918ba00007c","report"=>0,"cat"=>Time.now}.to_json

    #注销后添加黑名单
    logout
    post "/blacklists/create", {:user_id => luser.id, :block_id => user2.id}
    assert_response :success
    assert_equal response.body, {"error"=>"user 502e6303421aa918ba000005 != session user "}.to_json
    assert_equal luser.reload.blacks_s.count, 1
    assert luser.reload.blacks_s.detect{|data| data["id"] == user1.id}

    #登录黑名单列表
    login("502e6303421aa918ba000005")
    get "/blacklists?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert_equal data, [{"name"=>"袁乐天","signature"=>"","wb_uid"=>"a1", "gender"=>1.0,"birthday"=>"","jobtype"=>nil,"multip"=>false,"id"=>"502e6303421aa918ba00007c","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>false,"follower"=>false}]

    #注销后黑名单列表
    logout
    get "/blacklists?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert_equal data, [{"name"=>"袁乐天","signature"=>"","wb_uid"=>"a1", "gender"=>1.0,"birthday"=>"","jobtype"=>nil,"multip"=>false,"id"=>"502e6303421aa918ba00007c","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>false,"follower"=>false}]

    #再添加一个黑名单
    login("502e6303421aa918ba000005")
    post "/blacklists/create", {:user_id => luser.id, :block_id => user2.id}
    assert_response :success
    assert session_user.blacks_s.detect{|data| data["id"] == user2.id }
    assert_equal luser.reload.blacks_s.count, 2
    
    #未登录删除黑名单
    logout
    post '/blacklists/delete', {:user_id => luser.id, :block_id => user1.id}
    assert_response :success
    assert_equal response.body, {"error"=>"user 502e6303421aa918ba000005 != session user "}.to_json
    assert_equal luser.reload.blacks_s.count, 2
    assert luser.reload.blacks_s.detect{|data| data["id"] == user1.id}
    
    #登录删除黑名单
    login("502e6303421aa918ba000005")
    post '/blacklists/delete', {:user_id => session_user.id, :block_id => user1.id}
    assert_response :success
    assert_equal luser.reload.blacks_s.count, 1
    assert_equal luser.reload.blacks_s.detect{|data| data["id"] == user1.id}, nil

    #再删除黑名单
    post '/blacklists/delete', {:user_id => session_user.id, :block_id => user2.id}
    assert_response :success
    assert_equal luser.reload.blacks_s.count, 0
    assert_equal luser.reload.blacks_s.detect{|data| data["id"] == user2.id}, nil

  end
end

