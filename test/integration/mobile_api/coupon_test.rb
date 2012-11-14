# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'
class CouponTest < ActionDispatch::IntegrationTest
  test "推送优惠券，展示优惠券，使用优惠券"  do
    reload('users.js')
    reload('shops.js')
    reload('coupons.js')
    luser = User.find('502e6303421aa918ba000005')
    user1 = User.find('502e6303421aa918ba00007c')
    shop = Shop.find('4928288')
    first_sub_shop_last_coupon = Coupon.where({:shop_id => 1}).sort({:_id => -1}).to_a.first

    #初始状态shop没有优惠券， 子商家1优惠券都没有下载使用， 子商家2没有优惠券
    assert_equal Coupon.where({:shop_id => shop.id}).to_a, []
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users}, [nil,nil,nil,nil]
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #未登录签到
    post "/checkins/create",{:user_id => luser.id,:lat => '30.282661', :lng => '120.116997', :accuracy => '76',:shop_id => '4928288',:od => 1}
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal Coupon.where({:shop_id => shop.id}).to_a, []
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users}, [nil,nil,nil,nil]
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #登录签到推送优惠券
    login("502e6303421aa918ba000005")
    post "/checkins/create",{:user_id => luser.id,:lat => '30.282661', :lng => '120.116997', :accuracy => '76',:shop_id => '4928288',:od => 1}
    assert_response :success
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert Coupon.where({:shop_id => shop.id}).to_a.first.img
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [1,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] && u['dat']}, 1
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #重新加载优惠券
    reload('coupons.js')

    #登录签到另一用户
    logout
    login(user1.id)
    assert_raise RuntimeError do 
      raise(post "/checkins/create",{:user_id => luser.id,:lat => '30.282661', :lng => '120.116997', :accuracy => '76',:shop_id => '4928288',:od => 1})
    end
    assert_equal Coupon.where({:shop_id => shop.id}).to_a, []
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users}, [nil,nil,nil,nil]
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #登录签到推送优惠券
    login("502e6303421aa918ba000005")
    post "/checkins/create",{:user_id => luser.id,:lat => '30.282661', :lng => '120.116997', :accuracy => '76',:shop_id => '4928288',:od => 1}
    assert_response :success
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert Coupon.where({:shop_id => shop.id}).to_a.first.img
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [1,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] && u['dat']}, 1
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #再签到一次
    post "/checkins/create",{:user_id => luser.id,:lat => '30.282661', :lng => '120.116997', :accuracy => '76',:shop_id => '4928288',:od => 1}
    assert_response :success
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [2,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #另一用户签到
    logout
    login(user1.id)
    post "/checkins/create",{:user_id => user1.id,:lat => '30.282661', :lng => '120.116997', :accuracy => '76',:shop_id => '4928288',:od => 1}
    assert_response :success
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== user1.id && u['dat']}, 1
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == user1.id && u['dat']}, 1
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #未登录展示优惠券
    logout
    get "/coupons/img?id=#{Coupon.where({:shop_id => shop.id}).to_a.first.id}"
    assert_response :redirect
    assert_redirected_to Coupon.where({:shop_id => shop.id}).to_a.first.img.url

    #登录展示优惠券
    login(luser.id)
    get "/coupons/img?id=#{Coupon.where({:shop_id => shop.id}).to_a.first.id}"
    assert_response :redirect
    assert_redirected_to Coupon.where({:shop_id => shop.id}).to_a.first.img.url

    #未登录使用优惠券
    logout
    get "/coupons/use?id=#{Coupon.where({:shop_id => shop.id}).to_a.first.id}"
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== luser.id && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == luser.id && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #登录使用优惠券
    login(luser.id)
    get "/coupons/use?id=#{Coupon.where({:shop_id => shop.id}).to_a.first.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"used"=> Coupon.where({:shop_id => shop.id}).to_a.first.id.to_s}
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['uat']}, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== luser.id && u['uat']}, 1
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == luser.id && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #再使用优惠券
    login(luser.id)
    get "/coupons/use?id=#{Coupon.where({:shop_id => shop.id}).to_a.first.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"used"=> Coupon.where({:shop_id => shop.id}).to_a.first.id.to_s}
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['uat']}, 2
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== luser.id && u['uat']}, 2
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == luser.id && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 2}).to_a, []
    
    #使用子优惠券
    get "/coupons/use?id=#{first_sub_shop_last_coupon.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"used"=> first_sub_shop_last_coupon.id.to_s}
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['uat']}, 2
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== luser.id && u['uat']}, 2
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] && u['uat']}, 1
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == luser.id && u['uat']}, 1
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #再使用子优惠券
    get "/coupons/use?id=#{first_sub_shop_last_coupon.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"used"=> first_sub_shop_last_coupon.id.to_s}
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['uat']}, 2
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== luser.id && u['uat']}, 2
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] && u['uat']}, 2
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == luser.id && u['uat']}, 2
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #优惠券下载次数全使用
    logout
    login(user1.id)
    get "/coupons/use?id=#{Coupon.where({:shop_id => shop.id}).to_a.first.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"used"=> Coupon.where({:shop_id => shop.id}).to_a.first.id.to_s}
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['uat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== user1.id && u['uat']}, 1
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == luser.id && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #子优惠券下载次数全使用
    get "/coupons/use?id=#{first_sub_shop_last_coupon.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"used"=> first_sub_shop_last_coupon.id.to_s}
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['uat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== user1.id && u['uat']}, 1
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] && u['uat']}, 3
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == user1.id && u['uat']}, 1
    assert_equal Coupon.where({:shop_id => 2}).to_a, []

    #超过下载次数使用
    get "/coupons/use?id=#{Coupon.where({:shop_id => shop.id}).to_a.first.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"used"=> Coupon.where({:shop_id => shop.id}).to_a.first.id.to_s}
    assert_equal Coupon.where({:shop_id => shop.id}).count, 1
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['dat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id'] && u['uat']}, 3
    assert_equal Coupon.where({:shop_id => shop.id}).to_a.first.users.count{|u| u['id']== user1.id && u['uat']}, 1
    assert_equal Coupon.where({:shop_id => 1}).sort({:_id => -1}).map{|c| c.users.to_a.count}, [3,0,0,0]
    assert_equal first_sub_shop_last_coupon.reload.users.count{|u| u['id'] == luser.id && u['dat']}, 2
    assert_equal Coupon.where({:shop_id => 2}).to_a, []
    
  end
  
end