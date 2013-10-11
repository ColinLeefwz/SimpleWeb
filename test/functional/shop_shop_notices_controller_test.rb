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

end

