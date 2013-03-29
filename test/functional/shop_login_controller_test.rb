# coding: utf-8
require 'test_helper'

class ShopLoginControllerTest < ActionController::TestCase
  test '没登录跳转到登录页面' do
    get :index
    assert_redirected_to :action => "login"
  end

  test '没有的shop_id登陆' do
    post :login, :id => 20, :password => '123456'
    assert_equal "id没有找到.", flash[:notice]
  end

  test '没有开通密码的商家登陆' do
    post :login, :id => 112, :password => '123456'
    assert_equal "密码还没有开通.", flash[:notice]
  end

  test '商家使用错误的密码登陆' do
    post :login, :id => 2, :password => '123456222'
    assert_equal "密码错误.", flash[:notice]
  end

  test '登陆成功' do
    post :login, :id => 2, :password => '123456'
    assert_redirected_to "/shop_login/index"
  end
end

