# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class UserBlacksTest < ActionDispatch::IntegrationTest

  test "添加，删除，查看黑名单" do
    reload('users.js')
    reload('user_blacks.js')
    clear_cache_all(User)
    luser = User.find('502e6303421aa918ba000005')
    user1 = User.find('502e6303421aa918ba00007c')
    user2 = User.find('502e6303421aa918ba000002')

    #登录添加黑名单
    login("502e6303421aa918ba000005")
    assert_blank luser.blacks_s
    post "/blacklists/create", {:user_id => luser.id, :block_id => user1.id}
    assert_response :success
    assert luser.reload.blacks_s.detect{|data| data.bid == user1.id}
    assert_equal luser.reload.blacks_s.count, 1



    #注销后添加黑名单
    logout
    post "/blacklists/create", {:user_id => luser.id, :block_id => user2.id}
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal luser.reload.blacks_s.count, 1
    assert luser.reload.blacks_s.detect{|data| data.bid == user1.id}

    #登录后添加另一个人的黑名单
    logout
    login("502e6303421aa918ba00007c")
    post "/blacklists/create", {:user_id => luser.id, :block_id => user2.id}
    assert_response :success
    assert_equal response.body, {"error"=>"user 502e6303421aa918ba000005 != session user 502e6303421aa918ba00007c"}.to_json
    assert_equal luser.reload.blacks_s.count, 1
    assert luser.reload.blacks_s.detect{|data| data.bid == user1.id}

    #注销后黑名单列表
    logout
    get "/blacklists?id=#{luser.id}"
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json


    #登录黑名单列表
    login("502e6303421aa918ba000005")
    get "/blacklists?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert_equal data.map{|m| m.delete('last');m.delete('time'); m}, [{"name"=>"袁乐天","signature"=>"","wb_uid"=>"a1","gender"=>1.0,"birthday"=>"","jobtype"=>nil,"pcount"=>0,"id"=>"502e6303421aa918ba00007c","logo"=>"","logo_thumb"=>"","logo_thumb2"=>""}]

   
    #再添加一个黑名单
    login("502e6303421aa918ba000005")
    post "/blacklists/create", {:user_id => luser.id, :block_id => user2.id}
    assert_response :success
    assert luser.reload.blacks_s.detect{|data| data.bid == user2.id }
    assert_equal luser.reload.blacks_s.count, 2

    #未登录删除黑名单
    logout
    post '/blacklists/delete', {:user_id => luser.id, :block_id => user1.id}
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal luser.reload.blacks_s.count, 2
    assert luser.reload.blacks_s.detect{|data| data.bid == user1.id}

    #登录删除黑名单
    login("502e6303421aa918ba000005")
    post '/blacklists/delete', {:user_id => luser.id, :block_id => user1.id}
    assert_response :success
    assert_equal luser.reload.blacks_s.count, 1
    assert_equal luser.reload.blacks_s.detect{|data| data.bid == user1.id}, nil
    data = JSON.parse(response.body)
    assert_equal data, {"deleted"=>"502e6303421aa918ba00007c"}

    #登录后删除另一个用户的黑名单
    logout
    login("502e6303421aa918ba00007c")
    post '/blacklists/delete', {:user_id => luser.id, :block_id => user2.id}
    assert_response :success
    assert_equal response.body, {"error"=>"user 502e6303421aa918ba000005 != session user 502e6303421aa918ba00007c"}.to_json
    assert_equal luser.reload.blacks_s.count, 1
    assert luser.reload.blacks_s.detect{|data| data.bid == user2.id}
    
    #再删除黑名单
    login("502e6303421aa918ba000005")
    post '/blacklists/delete', {:user_id => luser.id, :block_id => user2.id}
    assert_response :success
    assert_equal luser.reload.blacks_s.count, 0
    assert_equal luser.reload.blacks_s.detect{|data| data.bid == user2.id}, nil
    data = JSON.parse(response.body)
    assert_equal data, {"deleted"=>"502e6303421aa918ba000002"}

  end
end

