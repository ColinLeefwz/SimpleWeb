# coding: utf-8
require 'test_helper'

class ShopLoginControllerTest < ActionController::TestCase

  def setup
    Rails.cache.delete("LE#{request.ip}")
  end


  test '没登录跳转到登录页面' do
    get :index
    assert_redirected_to :action => "login"
  end

  test '没有的shop_id登陆' do
    post :login, :id => 20, :password => '123456'
    assert_equal "id没有找到.", flash[:notice]
  end

  test '没有开通密码的商家登陆5次ip封一个小时' do
    post :login, :id => 112, :password => '123456'
    assert_equal "密码输入错误，您还有4次机会", flash[:notice]
    post :login, :id => 112, :password => '123456'
    assert_equal "密码输入错误，您还有3次机会", flash[:notice]
    post :login, :id => 112, :password => '123456'
    assert_equal "密码输入错误，您还有2次机会", flash[:notice]
    post :login, :id => 112, :password => '123456'
    assert_equal "密码输入错误，您还有1次机会", flash[:notice]
    post :login, :id => 112, :password => '123456'
    assert_equal "您的ip已经被锁定一小时，请稍后再试!", flash[:notice]
    post :login, :id => 2, :password => '123456'
    assert_equal "您的ip已经被锁定一小时，请稍后再试!", flash[:notice]
    
  end

  test '商家使用错误的密码登陆5次ip封一个小时' do
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有4次机会", flash[:notice]
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有3次机会", flash[:notice]
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有2次机会", flash[:notice]
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有1次机会", flash[:notice]
    post :login, :id => 2, :password => '1234561'
    assert_equal "您的ip已经被锁定一小时，请稍后再试!", flash[:notice]
  end

  test '商家使用错误的密码登陆4次后登陆成功' do
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有4次机会", flash[:notice]
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有3次机会", flash[:notice]
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有2次机会", flash[:notice]
    post :login, :id => 2, :password => '1234561'
    assert_equal "密码输入错误，您还有1次机会", flash[:notice]
    post :login, :id => 2, :password => '123456'
    assert_redirected_to "/shop_login/index"
  end
end

