# coding: utf-8
require 'test_helper'

class UserBlacksTest < ActionDispatch::IntegrationTest

  test "添加，删除，查看黑名单" do
    reload('users.js')
    user = User.find('502e6303421aa918ba00007c')
    #登录
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]
    assert_blank session_user.blacks_s

    #添加黑名单
    post "/blacklists/create", {:user_id => session_user.id, :block_id => user.id}
    assert_response :success
    assert session_user.blacks_s.detect{|data| data["id"] == user.id}

    #黑名单列表
    get "/blacklists?id=#{session_user.id}"
    assert_response :success
    data = JSON.parse(response.body).last['data']
    assert data.detect{|d| d['id'] == user.id.to_s}

    #删除黑名单
    post '/blacklists/delete', {:user_id => session_user.id, :block_id => user.id}
    assert_response :success
    assert_blank session_user.blacks_s

  end
end
