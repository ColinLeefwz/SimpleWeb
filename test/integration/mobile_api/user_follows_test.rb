# coding: utf-8
require 'test_helper'

class UserFollowsTest < ActionDispatch::IntegrationTest

  test "添加，删除，查看好友(粉丝)" do
    reload('users.js')
    #登录
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]
    user = User.find('502e6303421aa918ba00007c')
    assert_blank session_user.follows_s
    assert !user.follower?(session_user.id)

    #添加好友
    post "/follows/create",{:user_id => session_user.id, :follow_id => user.id}
    assert_response :success
    assert session_user.friend?(user.id)
    assert user.follower?(session_user.id)

    #粉丝列表
    get "/follow_info/followers?id=#{user.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert data.detect{|d| d['id'] == session_user.id.to_s}

    #好友列表
    get "/follow_info/friends?id=#{session_user.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert data.detect{|d| d['id'] == user.id.to_s}

    #删除好友
    post "follows/delete",{:user_id => session_user.id, :follow_id => '502e6303421aa918ba00007c' }
    assert_response :success
    assert_blank session_user.follows_s
    assert !user.follower?(session_user.id)

  end



end

