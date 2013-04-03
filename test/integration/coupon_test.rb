# coding: utf-8
require 'test_helper'
require 'integration/helpers/shop_web_helper'
require 'integration/helpers/mobile_helper'
class CouponTest < ActionDispatch::IntegrationTest
  IMG = 'public/images/test/test.jpg'
  
  test "优惠券发布，签到发送优惠券，子商家发送优惠券， 分店发送用户券"  do
    reload('users.js')
    reload('shops.js')
    Coupon.delete_all
    Checkin.delete_all
    
    #未登录发布签到优惠券
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>""}}
    assert_redirected_to(:controller => 'shop_login', :action => 'login' )
    #未登录发布分享优惠券
    post "/shop_coupons/create2",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>""}}
    assert_redirected_to(:controller => 'shop_login', :action => 'login' )

    #登录
    slogin(Shop.find(1).id)
    #分布签到优惠券，图文模式下规则是每日签到.
    #*****签到图文图片必须上传.
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"每日签到优惠", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>""}}
    assert_equal flash[:notice], "请上传图片."
    assert_template "create"
    assert_equal Coupon.count, 0
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"每日签到优惠", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_redirected_to :action => :show, :id => assigns[:coupon].id

    #发布签到优惠券，全图模式下规则是每日前1名优惠.
    #********签到全图图片必须上传.
    post "/shop_coupons/create",{"coupon"=>{"t"=>"2"}}
    assert_equal flash[:notice], "请上传图片."
    assert_template "create"
    assert_equal Coupon.count, 1
    post "/shop_coupons/create",{"coupon"=>{"t"=>"2","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_redirected_to :action => :show_img2, :id => assigns[:coupon].id
    post "/shop_coupons/crop", {"id"=>assigns[:coupon].id.to_s, "x"=>"0", "y"=>"0", "w"=>"350", "h"=>"190"}
    assert_redirected_to :action => :all_img, :id => assigns[:coupon].id
    put "/shop_coupons/#{assigns[:coupon].id.to_s}", {"coupon"=>{"name"=>"每日第一名优惠", "rule"=>"1", "rulev"=>"1"}}
    assert_redirected_to :action => :show, :id => assigns[:coupon].id
    assert_equal Coupon.count, 2

    #分布签到优惠券，图文模式下规则是用户首次签到.
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"发布后首次签到优惠", "desc"=>"点此输入描述", "rule"=>"2", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_redirected_to :action => :show, :id => assigns[:coupon].id
    assert_equal Coupon.count, 3

    #分布签到优惠券，图文模式下规则是签到满3次.
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"签到满二次优惠", "desc"=>"点此输入描述", "rule"=>"3", "rulev"=>"2","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_redirected_to :action => :show, :id => assigns[:coupon].id
    assert_equal Coupon.count, 4

    #签到类每种规则只能发一个
    #********图文模式下 每日签到
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal flash[:notice], "该商家已有一张有效的每日签到优惠类型的优惠券."
    assert_template "create"
    #********图文模式下 每日前几名签到
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"1", "rulev"=>"1","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal flash[:notice], "该商家已有一张有效的每日前几名签到优惠类型的优惠券."
    assert_template "create"
    #********图文模式下 首次签到
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"2", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal flash[:notice], "该商家已有一张有效的新用户首次签到优惠类型的优惠券."
    assert_template "create"
    #********图文模式下 累计签到
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"累计签到", "desc"=>"点此输入描述", "rule"=>"3", "rulev"=>"1","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal flash[:notice], "该商家已有一张有效的累计签到优惠类型的优惠券."
    assert_template "create"

    #全图模式下
    post "/shop_coupons/create",{"coupon"=>{"t"=>"2","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    post "/shop_coupons/crop", {"id"=>assigns[:coupon].id.to_s, "x"=>"0", "y"=>"0", "w"=>"350", "h"=>"190"}
    #********全图模式下 每日签到
    put "/shop_coupons/#{assigns[:coupon].id.to_s}", {"coupon"=>{"name"=>"每日第一名优惠", "rule"=>"0", "rulev"=>"1"}}
    assert_equal flash[:notice], "该商家已有一张有效的每日签到优惠类型的优惠券."
    assert_template "all_img"
    #********图图模式下 每日前几名签到
    put "/shop_coupons/#{assigns[:coupon].id.to_s}", {"coupon"=>{"name"=>"每日第一名优惠", "rule"=>"1", "rulev"=>"1"}}
    assert_template "all_img"
    assert_equal flash[:notice], "该商家已有一张有效的每日前几名签到优惠类型的优惠券."
    #********全图模式下 首次签到
    put "/shop_coupons/#{assigns[:coupon].id.to_s}", {"coupon"=>{"name"=>"每日第一名优惠", "rule"=>"2", "rulev"=>"1"}}
    assert_template "all_img"
    assert_equal flash[:notice], "该商家已有一张有效的新用户首次签到优惠类型的优惠券."
    #********全图模式下 累计签到
    put "/shop_coupons/#{assigns[:coupon].id.to_s}", {"coupon"=>{"name"=>"每日第一名优惠", "rule"=>"3", "rulev"=>"1"}}
    assert_template "all_img"
    assert_equal flash[:notice], "该商家已有一张有效的累计签到优惠类型的优惠券."
    assigns[:coupon].delete

    ############################################################################################
    #分享类优惠券发布
    #图文模式发布可以不上传图片
    post "/shop_coupons/create2",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好"}}
    coupon = assigns[:coupon]
    assert_redirected_to :action => :show, :id => assigns[:coupon].id
    assert_equal Coupon.count, 5
    #分享类只能发布一张有效的
    #***** 发布图文
    post "/shop_coupons/create2",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好"}}
    assert_equal flash[:notice], "该商家已有一张未停用分享类优惠券."
    #***** 发布全图
    post "/shop_coupons/create2", {"coupon"=>{"t"=>"2", "name"=>"", "rule"=>"0", "text"=>""}}
    assert_equal flash[:notice], "该商家已有一张未停用分享类优惠券."
    assert_equal Coupon.count, 5

    # 发布分享类全图模式
    coupon.delete
    assert_equal Coupon.count, 4
    #全图模式必须上传图片
    post "/shop_coupons/create2", {"coupon"=>{"t"=>"2", "name"=>"", "rule"=>"0", "text"=>""}}
    assert_equal flash[:notice], "请上传图片."
    assert_template "create2"
    assert_equal Coupon.count, 4
    post "/shop_coupons/create2", {"coupon"=>{"t"=>"2", "name"=>"", "rule"=>"0", "text"=>"", "img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_redirected_to :action => :show, :id => assigns[:coupon].id
    assert_equal Coupon.count, 5


    ##########################################################################
    #子商家发布优惠券
    slogout
    slogin(2)
    #签到类
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"2每日签到优惠", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal Coupon.count, 6
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"2首次签到", "desc"=>"点此输入描述", "rule"=>"2", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal Coupon.count, 7
    #分享类
    post "/shop_coupons/create2",{"coupon"=>{"t"=>"1", "name"=>"2分享优惠", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal Coupon.count, 8

    ############################################################################
    #分店发布优惠券
    slogout
    slogin(111)
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"111每日签到优惠", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal Coupon.count, 9
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"2", "rulev"=>"","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal Coupon.count, 10
    #分享类
    post "/shop_coupons/create2",{"coupon"=>{"t"=>"1", "name"=>"111分享优惠", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
    assert_equal Coupon.count, 11


    #########################################################################################
    #总店签到， 只能收到内部店的每日签到优惠
    login("502e6303421aa918ba000005")
    #用户签到优惠，总店发分店的签到。
    $redis.zremrangebyrank("ckin1", 0,-1)
    $redis.zremrangebyrank("ckin2", 0,-1)
    $redis.zremrangebyrank("ckin111", 0,-1)
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 1, :user_id =>'502e6303421aa918ba000005', :od => 1 }
    assert_equal assigns[:send_coupon_msg], '收到4张优惠券: 发布后首次签到优惠,每日第一名优惠,每日签到优惠,2每日签到优惠'
    #用户第二次签到，不发送优惠券。
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 1, :user_id =>'502e6303421aa918ba000005', :od => 1 }
    assert_equal assigns[:send_coupon_msg], nil

    #另一用户签到收不到第一名签到优惠。 但可以收到累计签到优惠2次优惠.
    logout
    user = User.find('502e6303421aa918ba00007c')
    login(user.id)
    Checkin.mongo_session['checkins'].insert(:_id => "502d6303421aa918ba00007c".__mongoize_object_id__, :uid => user.id, :sid => 1)
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 1, :user_id => user.id, :od => 1 }
    assert_equal assigns[:send_coupon_msg], '收到4张优惠券: 签到满二次优惠,发布后首次签到优惠,每日签到优惠,2每日签到优惠'

    ####内部店签到，只能收到内部店的优惠
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 2, :user_id => user.id, :od => 1 }
    assert_equal assigns[:send_coupon_msg], '收到2张优惠券: 2首次签到,2每日签到优惠'
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 2, :user_id => user.id, :od => 1 }
    assert_equal assigns[:send_coupon_msg], nil

    #######

    
  end
  
end