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
    CouponDown.delete_all
    Photo.delete_all
    
    #未登录发布签到优惠券
    post "/shop_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>""}}
    assert_redirected_to(:controller => 'shop_login', :action => 'login' )
    #未登录发布分享优惠券
    post "/shop_share_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "rulev"=>""}}
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
    post "/shop_share_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好"}}
    coupon = assigns[:coupon]
    assert_redirected_to :action => :show, :id => assigns[:coupon].id
    assert_equal Coupon.count, 5
    #分享类只能发布一张有效的
    #***** 发布图文
    post "/shop_share_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"点此输入名称", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好"}}
    assert_equal flash[:notice], "该商家已有一张未停用分享类优惠券."
    #***** 发布全图
    post "/shop_share_coupons/create", {"coupon"=>{"t"=>"2", "name"=>"", "rule"=>"0", "text"=>""}}
    assert_equal flash[:notice], "该商家已有一张未停用分享类优惠券."
    assert_equal Coupon.count, 5

    # 发布分享类全图模式
    coupon.delete
    assert_equal Coupon.count, 4
    #全图模式必须上传图片
    post "/shop_share_coupons/create", {"coupon"=>{"t"=>"2", "name"=>"", "rule"=>"0", "text"=>""}}
    assert_equal flash[:notice], "请上传图片."
    assert_template "create"
    assert_equal Coupon.count, 4
    post "/shop_share_coupons/create", {"coupon"=>{"t"=>"2", "name"=>"", "rule"=>"0", "text"=>"", "img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
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
    post "/shop_share_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"2分享优惠", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
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
    post "/shop_share_coupons/create",{"coupon"=>{"t"=>"1", "name"=>"111分享优惠", "desc"=>"点此输入描述", "rule"=>"0", "text"=>"好","img2" => Rack::Test::UploadedFile.new(IMG, "image/jpeg")}}
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
    assert_equal assigns[:send_coupon_msg], '收到3张优惠券: 发布后首次签到优惠,每日签到优惠,2每日签到优惠'
    #先判断优惠券条件，后保存签到。所以累计签到优惠要下一次才能触发
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 1, :user_id => user.id, :od => 1 }
    assert_equal assigns[:send_coupon_msg], '收到1张优惠券: 签到满二次优惠'

    ####内部店签到，只能收到内部店的优惠, 且大地点拿过优惠券， 内部店不能拿到
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 2, :user_id => user.id, :od => 1 }
    assert_equal assigns[:send_coupon_msg], '收到1张优惠券: 2首次签到'
    post "/checkins", {:lat => '30.28', :lng => "120.80", "accuract" => 65, :shop_id => 2, :user_id => user.id, :od => 1 }
    assert_equal assigns[:send_coupon_msg], nil

    #######
    #总店分享优惠券
    parent_coupon = Coupon.where({:t2 => 2, :shop_id => 1}).to_a.first
    #分店分享优惠券
    branch_coupon = Coupon.where({:t2 => 2, :shop_id => 111}).to_a.first
    #登录
    login("502e6303421aa918ba000005")
    #总店上传图片并分享到微博可以接收分享类优惠券
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '1', 'weibo' => 1 }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert parent_coupon.reload.down_users.detect{|du| du.uid.to_s == '502e6303421aa918ba000005' && du.dat.to_date == Time.now.to_date  }

    #今天总店上传图片并分享到微博后不能再收到优惠券
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '1', 'weibo' => 1 }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert_equal parent_coupon.reload.down_users.to_a.count, 1

    #优惠券下载时间改为昨天
    CouponDown.last.update_attribute(:dat, 1.days.ago)

    #规则改成首次分享优惠后就不能收到优惠券
    parent_coupon.update_attribute(:rule, 1)
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '1', 'weibo' => 1 }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert_equal parent_coupon.reload.down_users.to_a.count, 1


    #规则改成每日分享优惠后能收到优惠券
    parent_coupon.update_attribute(:rule, 0)
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '1', 'weibo' => 1 }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert parent_coupon.reload.down_users.detect{|du| du.uid.to_s == '502e6303421aa918ba000005' && du.dat.to_date == Time.now.to_date  }
    assert_equal parent_coupon.reload.down_users.to_a.count, 2


    #清空优惠券下载记录
    CouponDown.delete_all
    
    #内部商家分享图片不能接受优惠券
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '2', 'weibo' => 1 }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert_equal parent_coupon.reload.down_users.to_a, []
    
    #分店取消关键字
    branch_coupon.unset(:text)
    
    #分店分享图片能接收到总店和分店的优惠券
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '111', 'weibo' => 1 }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert parent_coupon.reload.down_users.find{|du| du.uid.to_s == '502e6303421aa918ba000005' && du.dat.to_date == Time.now.to_date && du.sub_sid.to_i == 111  }
    assert branch_coupon.reload.down_users.find{|du| du.uid.to_s == '502e6303421aa918ba000005' && du.dat.to_date == Time.now.to_date }
    
    #清空优惠券下载记录
    CouponDown.delete_all
    #总店分享类优惠券添加关键字
    parent_coupon.update_attribute(:text, '总店分享')

    #总店分享图片到微博描叙不匹配关键字
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '1', 'weibo' => 1, 'desc' => "不在" }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert_equal parent_coupon.reload.down_users.to_a, []

    #总店分享图片到微博并匹配关键字
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '1', 'weibo' => 1, 'desc' => "我在总店分享图片" }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert parent_coupon.reload.down_users.find{|du| du.uid.to_s == '502e6303421aa918ba000005' && du.dat.to_date == Time.now.to_date  }

    #分店优惠券清空下载记录
    CouponDown.delete_all(:sub_sid => 111)
    #分店分享优惠券添加关键字
    branch_coupon.update_attribute(:text, "分店分享")

    #总店分享后，分店分享图片可以带的关键字同时满足总分点的关键字， 但不能获取总店的优惠券
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '111', 'weibo' => 1, 'desc' => "分店分享一次，还可以总店分享一次" }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert_equal parent_coupon.reload.down_users.count, 1
    assert branch_coupon.reload.down_users.find{|du| du.uid.to_s == '502e6303421aa918ba000005' && du.dat.to_date == Time.now.to_date }

    #分店再次分享图片总店和分店的优惠券都不能接收到
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '111', 'weibo' => 1, 'desc' => "分店分享一次，还可以总店分享一次" }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert_equal parent_coupon.reload.down_users.to_a.length, 1
    assert_equal branch_coupon.reload.down_users.length, 1

    ####################
    #总店优惠券规则改成首次签到优惠， 并清空下载记录
    parent_coupon.update_attribute(:rule, 1)
    CouponDown.delete_all

    #在分店1分享图片能收到优惠券
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '111', 'weibo' => 1, 'desc' => "分店分享一次，还可以总店分享一次" }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert parent_coupon.reload.down_users.find{|du| du.uid.to_s == '502e6303421aa918ba000005' && du.dat.to_date == Time.now.to_date && du.sub_sid.to_i == 111  }

    #总店优惠券在分店1分享后， 在分店2不能被分享。
    post "/photos/create", {"photo" => {'img' =>  Rack::Test::UploadedFile.new(IMG, "image/jpeg"), 'room' => '112', 'weibo' => 1, 'desc' => "分店分享一次，还可以总店分享一次" }}
    assert_response :success
    photo = Photo.where({}).sort({:_id => -1}).limit(1).to_a.first
    CarrierWave::Workers::StoreAsset.perform("Photo",photo.id.to_s,"img")
    assert_equal parent_coupon.reload.down_users.to_a.count, 1
    
  end
  
end