# coding: utf-8
require 'test_helper'

class ShopShopNoticesControllerTest < ActionController::TestCase
  def setup
    db_connection.eval(File.read("#{Rails.root}/test/fixtures/shop_notices.js"))
  end
  
  test '没登录看公告列表' do
    get :index
    assert_redirected_to :controller => :shop_login, :action => :login
  end

  test '公告列表默认查看有效' do
    shop_login(3)
    get :index
    assert_equal 1, assigns[:shop_notices].length
    assert assigns[:shop_notices].first.effect
  end

  test '查看有效公告' do
    shop_login(3)
    get :index, :effect => 1
    assert_equal 1, assigns[:shop_notices].length
    assert assigns[:shop_notices].first.effect
  end

  test '查看过期公告' do
    shop_login(3)
    get :index, :effect => 0
    assert_equal 1, assigns[:shop_notices].length
    assert !assigns[:shop_notices].first.effect
  end

  test '所有公告' do
    shop_login(3)
    get :index, :effect => ''
    assert_equal 2, assigns[:shop_notices].length
  end

  test '没有登录不能发布公告' do
    post :create, :shop_notice => {:title => '测试', :ord => 2}
    assert_redirected_to :controller => :shop_login, :action => :login
  end

  test '发布公告时等于或小于新公告排序的全部有效公告排序加1' do
    shop_login(3)
    post :create, :shop_notice => {:title => '测试', :ord => 1}
    assert_equal 2, ShopNotice.find('507fc5bfc9ad42d756a412e4').ord.to_i
    assert_equal 3, ShopNotice.find("507fc5ffc9ad42d756a412e8").ord.to_i
    assert_redirected_to :action => :show, :id => assigns[:shop_notice].id
  end
end

