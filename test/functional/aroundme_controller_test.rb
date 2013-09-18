# coding: utf-8
require 'test_helper'

class AroundmeControllerTest < ActionController::TestCase

 
  def user_login(user_id)
    session[:user_id] = user_id
    raise("登录失败！") if User.find(user_id).id.to_s != session[:user_id]
  end


  test '员工定位显示加入的商家' do
    user_login("502e6303421aa918ba000001")
    get :shops, { lat: 30.279768, lng:120.108162, accuracy: 10 }
    data = JSON.parse(response.body)
    #浙江科技产业大厦为了测能不能取到点范围内的商家，脸脸商厦为了测员工加入的商家
    assert_equal(["西湖国际科技大厦","浙江科技产业大厦"], data.map{|m| m['name']})
    # assert_equal(["西湖国际科技大厦","浙江科技产业大厦","脸脸商厦","听•说"], data.map{|m| m['name']})
  end
  
end