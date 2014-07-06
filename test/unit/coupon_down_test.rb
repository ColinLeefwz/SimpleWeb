# coding: utf-8
require 'test_helper'

class CouponDownTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    CouponDown.delete_all
    reload('coupons.js')
  end

  test ".download(coupon, user_id, photo_id=nil, sid = nil) 下载优惠券" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    user = User.find('502e6303421aa918ba00007c')
    user2 = User.find('502e6303421aa918ba000002')
    assert_equal CouponDown.download(coupon, user.id).attributes.slice("cid", "sid","uid"), {"cid"=>coupon.id, "sid"=>1, "uid"=> user.id}
  end

  test ".download(coupon, user_id, photo_id=nil, sid = nil) 分店下载优惠券" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    user = User.find('502e6303421aa918ba00007c')
    user2 = User.find('502e6303421aa918ba000002')
    assert_equal CouponDown.download(coupon, user.id,nil, 111).attributes.slice("cid", "sid","uid", 'd_sid'), {"cid"=>coupon.id, "sid"=>1, "uid"=> user.id, 'd_sid' => 111}
  end

  test "#use(user_id, data) 用户没下载使用优惠券报错" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    user = User.find('502e6303421aa918ba00007c')
    user2 = User.find('502e6303421aa918ba000002')
    down = CouponDown.download(coupon, user.id)
    assert_raise RuntimeError do
      down.use(user2.id, nil)
    end
  end

  test "#use(user_id, data) 用户使用优惠券" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    user = User.find('502e6303421aa918ba00007c')
    user2 = User.find('502e6303421aa918ba000002')
    down = CouponDown.download(coupon, user.id)
    assert_equal down.use(user.id, nil), true
  end

  
end
