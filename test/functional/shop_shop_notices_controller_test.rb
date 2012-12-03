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
    assert_response :success
    assert_equal ShopNotice.where({shop_id: 3}).last, assigns[:shop_notice]
  end




end

