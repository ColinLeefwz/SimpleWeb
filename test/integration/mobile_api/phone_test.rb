# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'
class PhoneTest < ActionDispatch::IntegrationTest

  test "手机号码注册，登录，找回密码"  do
    phone1 = "15267134597"
    phone2 = "15267134598"
    code = '123456'
    reload('users.js')
    #获取验证码失败
    post "/phone/init", {phone: phone1}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"无法给手机15267134597发送验证码"}, data)

    #获取验证码成功
    post "/phone/init", {phone: phone1, flag: true}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"code"=>"56aabeb910e1e22c"}, data)

    #手机号码注册, 错误的验证码
    post "/phone/register",{phone: phone1, code: 'jsfjs', password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"验证码错误"}, data)

    #手机号码注册, 正确的验证码
    post "/phone/register",{phone: phone1, code: code, password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    
    #获取新建的用户
    user = User.last
    assert_equal(data['id'], user.id.to_s)
    assert_equal(data['phone'], user.phone)
    #退出
    logout

    #手机号码登录, 错误手机号
    post "/phone/login", {phone: phone2 , password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"手机号码或者密码不正确"}, data)
    assert_equal session[:user_id], nil

    #手机号码登录, 错误密码
    post "/phone/login", {phone: phone1 , password: '123456789'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"手机号码或者密码不正确"}, data)
    assert_equal session[:user_id], nil

    #手机号码登录, 成功登录
    post "/phone/login", {phone: phone1 , password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], user.id.to_s
    assert_equal session[:user_id], user.id
    #退出
    logout

    #手机号码再次注册
    post "/phone/init", {phone: phone1, flag: true}
    post "/phone/register",{phone: phone1, code: code, password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"手机号码不可用或已被注册"}, data)

    #清空session 
    session.destroy
    #获取验证码
    post "/phone/init", {phone: phone1, flag: true}

    #忘记密码, 不存在的手机号码用户忘记密码
    post "/phone/forgot_password",{phone: phone2, code: code, password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"手机号码不存在"}, data)

    #忘记密码, 存在的手机号码用户忘记密码，发送错误验证码
    post "/phone/forgot_password",{phone: phone1, code: '123222', password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"验证码错误"}, data)

    #忘记密码, 存在的手机号码用户忘记密码，发送正确验证码
    post "/phone/forgot_password",{phone: phone1, code: code, password: '123456789'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal(user.reload.password, Digest::SHA1.hexdigest(":dFace.#{123456789}@cn")[0,16])

    #清空session
    session.destroy

    #登录， 密码已经修改， 旧密码登录失败
    post "/phone/login", {phone: phone1 , password: '12345678'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"手机号码或者密码不正确"}, data)
    assert_equal session[:user_id], nil

    #登录， 密码已经修改， 新密码登录成功
    post "/phone/login", {phone: phone1 , password: '123456789'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], user.id.to_s
    assert_equal session[:user_id], user.id

    #修改密码， 原始密码错误
    post "/phone/change_password", {oldpass: "123456", password: '123qwe'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"原密码输入错误"}, data)
    assert_equal(user.reload.password, Digest::SHA1.hexdigest(":dFace.123456789@cn")[0,16])
 
    #修改密码， 原始密码正确
    post "/phone/change_password", {oldpass: "123456789", password: '123qwe'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], user.id.to_s
    assert_equal(user.reload.password, Digest::SHA1.hexdigest(":dFace.123qwe@cn")[0,16])

    #退出，新密码登录
    logout

    #手机号码登录, 修改前密码密码登录
    post "/phone/login", {phone: phone1 , password: '123456789'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal({"error"=>"手机号码或者密码不正确"}, data)
    assert_equal session[:user_id], nil

    #手机号码登录, 成功登录
    post "/phone/login", {phone: phone1 , password: '123qwe'}
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], user.id.to_s
    assert_equal session[:user_id], user.id

  end
  
end