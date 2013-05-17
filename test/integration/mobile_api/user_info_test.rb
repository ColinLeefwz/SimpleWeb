# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class UserInfoTest < ActionDispatch::IntegrationTest
  test "设置，查看个人信息" do
    reload('users.js')
    reload("checkins.js")
    reload("user_follows.js")
    clear_cache_all(User)
    
    luser = User.find('502e6303421aa918ba000005')
    user1 = User.find('502e6303421aa918ba00007c')
    #luser.del_my_cache
    #user1.del_my_cache

    #未登录获取当前用户信息
    get "/user_info/get_self"
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json

    #登录获取当前登录用户信息
    login(luser.id)
    get "/user_info/get_self"
    assert_response :success
    assert_equal JSON.parse(response.body), {"gender"=>1.0,"hobby"=>"","invisible"=>0.0,"jobtype"=>nil,"name"=>"袁乐天","oid"=>154.0,"password"=>"c84dad462d5b7282","signature"=>"","wb_uid"=>"a1","pcount"=>0,"id"=>"502e6303421aa918ba000005","logo"=>"","logo_thumb"=>"","logo_thumb2"=>""}

    #未登录获取他人个人信息
    logout
    get "/user_info/get?id=#{luser.id}"
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json

    #登录获取他人个人信息
    login(user1.id)
    get "/user_info/get?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body)
    data.delete('last')
    data.delete('time')
    assert_equal data, {"gender"=>1.0,"hobby"=>"","invisible"=>0.0,"jobtype"=>nil,"name"=>"袁乐天","oid"=>154.0,"signature"=>"","wb_uid"=>"a1","pcount"=>0,"id"=>"502e6303421aa918ba000005","logo"=>"","logo_thumb"=>"","logo_thumb2"=>"","friend"=>false,"follower"=>false}

    #未登录设置个人信息
    logout
    post '/user_info/set', {:name => "测试name", :gender => 1, :birthday => '1988-08-08', :signature => '测试签名档', :job => '程序员', :jobtype => 1, :hobby => '计算机', :invisible => 0}
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal luser.reload.attributes, {"_id"=> luser.id,"gender"=>1.0,"hobby"=>"","invisible"=>0.0,"jobtype"=>nil,"name"=>"袁乐天","oid"=>154.0,"password"=>"c84dad462d5b7282","signature"=>"","wb_uid"=>"a1","pcount"=>0}

    #登录设置个人信息
    login(luser.id)
    post '/user_info/set', {:name => "测试name", :gender => 1, :birthday => '1988-08-08', :signature => '测试签名档', :job => '程序员', :jobtype => 1, :hobby => '计算机', :invisible => 0}
    assert_response :success
    assert_equal JSON.parse(response.body), {"_id"=> '502e6303421aa918ba000005',"gender"=>1,"hobby"=>"计算机","invisible"=>0,"jobtype"=>1,"name"=>"测试name","oid"=>154.0,"password"=>"c84dad462d5b7282","signature"=>"测试签名档","wb_uid"=>"a1","pcount"=>0,"birthday"=>"1988-08-08","job"=>"程序员"}

    #登录获取当前登录用户信息
    logout
    login(luser.id)
    get "/user_info/get_self"
    assert_response :success
    assert_equal JSON.parse(response.body), {"birthday"=>"1988-08-08","gender"=>1.0,"hobby"=>"计算机","invisible"=>0.0,"job"=>"程序员","jobtype"=>1,"name"=>"测试name","oid"=>154.0,"password"=>"c84dad462d5b7282","pcount"=>0,"signature"=>"测试签名档","wb_uid"=>"a1","id"=>"502e6303421aa918ba000005","logo"=>"","logo_thumb"=>"","logo_thumb2"=>""}

  end
  
  test "测试caches_action" do
    Rails.cache.clear
    ActionController::Base.perform_caching = true
    luser = User.find('502e6303421aa918ba000005')
    login(luser.id)
    get "/user_info/photos?id=#{luser.id}"
    assert_response :success
    #TODO: 如何测试caches_action
    #assert Rails.cache.read("views/UIP#{luser.id}.json") != nil
    ActionController::Base.perform_caching = false
  end
  
end

