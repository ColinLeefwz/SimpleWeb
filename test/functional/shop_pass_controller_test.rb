# coding: utf-8
require 'test_helper'

class ShopPassControllerTest < ActionController::TestCase

    def setup
    reload("shops.js")
  end
  
  test '没有登录' do
    get :index
    assert_redirected_to :controller => :shop_login, :action => :login
  end
  test '原始密码不正确' do
    shop_login(2)
    post :index,{:oldpass => '123123213'}
    assert_equal '原来的密码输入不正确！', flash[:notice]
  end

  test '两次密码不一致' do
    shop_login(2)
    post :index,{:oldpass => '123456',"shop" => {:password => '123456', :password_confirmation => '654321'}}
    assert_equal '密码修改失败,请确保两次密码一致.', flash[:notice]
  end

  test '密码修改成功' do
    Shop.find(3).del_my_cache
    shop_login(3)
    post :index,{:oldpass => '123456',"shop" => {:password => '1234567', :password_confirmation => '1234567'}}
    assert_equal '密码修改成功.', flash[:notice]
    assert_equal '1234567', assigns[:shop].password
    assert_redirected_to '/shop_login/index'
  end

end

