# coding: utf-8
require 'test_helper'

class CouponTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    reload('coupons.js')
    reload('checkins.js')
  end



  test ".use(user_id) 优惠券第一次使用。" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e2')
    user = User.find('502e6303421aa918ba000005')
    coupon.download(user.id)
    coupon.use(user.id)
    assert_equal coupon.users.first.keys, ['id', 'dat', 'uat']
  end

  test ".use(user_id) 优惠券同一用户第二次使用。" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e2')
    user = User.find('502e6303421aa918ba000005')
    coupon.download(user.id)
    coupon.use(user.id)
    coupon.download(user.id)
    coupon.use(user.id)
    assert_equal coupon.users.select{|s| s['id'] == user.id}.map { |m| m.keys }, [['id', 'dat', 'uat'],['id', 'dat', 'uat']]
  end
  
  test "#allow_send_checkin? 规则是新用户首次签到优惠，新用户签到第一次可以发优惠券， 第二次不可以发。 " do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e3')
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), true
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
  end

  test "#allow_send_checkin? 规则是新用户首次签到优惠， 老用户签到 " do
    user = User.find('502e6303421aa918ba00007c')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e3')
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
  end

  test "#allow_send_checkin? 规则是累计签到优惠， 第三次签到才可以发优惠券。超过部分不发" do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e4')
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), true
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
  end
  
end
