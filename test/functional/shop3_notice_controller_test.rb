# coding: utf-8
require 'test_helper'

class Shop3NoticeControllerTest < ActionController::TestCase
  def setup
    reload("shop_notices.js")
  end
  
  test '没登录看公告列表' do
    get :index
    assert_redirected_to :controller => :shop3_login, :action => :login
  end

end

