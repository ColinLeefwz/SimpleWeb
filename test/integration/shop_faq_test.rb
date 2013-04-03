# coding: utf-8
require 'test_helper'
require 'integration/helpers/shop_web_helper'
require 'integration/helpers/mobile_helper'
class ShopFaqTest < ActionDispatch::IntegrationTest
  IMG = 'public/images/test/test.jpg'
  
  test "问答系统发布，回答"  do
    reload('users.js')
    reload('shops.js')
    ShopFaq.delete_all
    
    #未登录发布文答
    post "/shop_faqs/create",{"shop_faq"=>{"od"=>"01", "title"=>"获取wifi密码", "text"=>"1111"}}
    assert_redirected_to(:controller => 'shop_login', :action => 'login' )

    #登录
    slogin(Shop.find(1).id)
    #发布纯文本问题
    post "/shop_faqs/create",{"shop_faq"=>{"od"=>"01", "title"=>"获取wifi密码", "text"=>"1111"}}
    assert_redirected_to :action => :show, :id => assigns[:shop_faq].id
    assert_equal ShopFaq.count, 1

    #发布纯图片问题
    post "/shop_faqs/create",{"shop_faq"=>{"od"=>"02", "title"=>"商家图片", "img"=>Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_redirected_to :action => :show, :id => assigns[:shop_faq].id
    faq2 = assigns[:shop_faq]
    assert_equal ShopFaq.count, 2
    #发布图文混合问题
    post "/shop_faqs/create",{"shop_faq"=>{"od"=>"03", "title"=>"今天特色","text"=>"今天特色是没有特色", "img"=>Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_redirected_to :action => :show, :id => assigns[:shop_faq].id
    faq3 = assigns[:shop_faq]
    assert_equal ShopFaq.count, 3


    #发布问道序号不能是空
    post "/shop_faqs/create",{"shop_faq"=>{ "title"=>"获取wifi密码", "text"=>"1111"}}
    assert_template :action => :new
    assert_equal assigns[:shop_faq].errors[:od], ["序号不能是空."]
    #发布问道标题不能是空
    post "/shop_faqs/create",{"shop_faq"=>{ "od"=>"04", "text"=>"1111"}}
    assert_template :action => :new
    assert_equal assigns[:shop_faq].errors[:title], ['标题不能是空.']
    #发布问题文本和图片不能同时为空
    post "/shop_faqs/create",{"shop_faq"=>{"od"=>"04", "title"=>"获取wifi密码"}}
    assert_template :action => :new
    assert_equal assigns[:shop_faq].errors[:img], ['文本和图片至少有一个存在.']

    #商家登出
    slogout
    #用户登录
    login("502e6303421aa918ba000005")

    #发送0
    get "/answer/shop?sid=#{Shop.find(1).id}&uid=502e6303421aa918ba000005&msg=0"
    assert_equal assigns[:text], "试试回复：\n01=>获取wifi密码.\n02=>商家图片.\n03=>今天特色."
    #发送01
    get "/answer/shop?sid=#{Shop.find(1).id}&uid=502e6303421aa918ba000005&msg=01"
    assert_equal assigns[:text], '1111'

    #发送02
    get "/answer/shop?sid=#{Shop.find(1).id}&uid=502e6303421aa918ba000005&msg=02"
    assert_equal assigns[:text], "[img:faq#{faq2.id.to_s}]"

    #发送03
    get "/answer/shop?sid=#{Shop.find(1).id}&uid=502e6303421aa918ba000005&msg=03"
    assert_equal assigns[:text], "[img:faq#{faq3.id.to_s}]今天特色是没有特色"

    #发送04
    get "/answer/shop?sid=#{Shop.find(1).id}&uid=502e6303421aa918ba000005&msg=04"
    assert_equal assigns[:text], "试试回复：\n01=>获取wifi密码.\n02=>商家图片.\n03=>今天特色."

    #发送1
    get "/answer/shop?sid=#{Shop.find(1).id}&uid=502e6303421aa918ba000005&msg=1"
    assert_equal assigns[:text], nil
   
  end
  
end