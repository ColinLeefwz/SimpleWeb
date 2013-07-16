# coding: utf-8
require 'test_helper'

class CouponTest < ActiveSupport::TestCase
  $ActiveShops = [1]
  # test "the truth" do
  #   assert true
  # end
  def setup
    reload('coupons.js')
    reload('checkins.js')
    CouponDown.delete_all
    $redis.keys("ckin*").each{|key| $redis.zremrangebyrank(key, 0, -1)}
  end

  test "#allow_send_checkin? 规则是每日签到签到优惠，用户下载一次后不能在下载 " do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    assert_equal coupon.allow_send_checkin?(user._id.to_s), true
    CouponDown.download(coupon, user.id)
    assert_equal coupon.allow_send_checkin?('502e6303421aa918ba000005'), false
  end

  test "#allow_send_checkin? 规则是每日前2名签到优惠，第三个用户签到不能发优惠券 " do
    user = User.find('502e6303421aa918ba000005')
    user2 = User.find('502e6303421aa918ba00007c')
    user3 = User.find('502e6303421aa918ba000001')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e2')
    checkin1 = Checkin.create!(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), true
    checkin1.add_to_redis
    checkin2 = Checkin.create!(uid: user2._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user2._id), true
    checkin2.add_to_redis
    assert_equal coupon.allow_send_checkin?(user3._id), nil
  end

  test "#allow_send_checkin? 规则是新用户首次签到优惠， 没签过到发优惠券，签过不发 " do
    user = User.find('502e6303421aa918ba00007c')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e3')
    assert_equal coupon.allow_send_checkin?(user._id), true
    CouponDown.download(coupon, user.id)
    assert_equal coupon.allow_send_checkin?(user._id), false
  end

  test "#allow_send_checkin? 规则是累计签到三天， 第三天签到才可以发优惠券。超过部分不发" do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e4')
    #添加一个当前之前的签到
    Checkin.mongo_session['checkins'].insert(_id: "502e6303421aa918ba00007c".__mongoize_object_id__,uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), false
    Checkin.mongo_session['checkins'].insert(_id: "502d6303421aa918ba00007c".__mongoize_object_id__,uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), false
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), true
    #优惠券只能下载一个
    CouponDown.download(coupon, user.id)
    assert_equal coupon.allow_send_checkin?(user._id), false
  end


  test "#allow_send_checkin? 7月18活动 合作商家签到优惠券发送" do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    assert_equal coupon.allow_send_checkin?(user._id.to_s), true
  end

  test "#allow_send_checkin? 7月18活动 今天发的优惠券使用后不能收到优惠券" do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    CouponDown.download(coupon, user.id).use(user.id, nil)
    assert_equal coupon.allow_send_checkin?(user._id.to_s), false
  end

  test "#allow_send_checkin? 7月18活动 合作商家昨天优惠券未使用今天不发优惠券， 使用后可以发优惠券" do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    CouponDown.download(coupon, user.id).update_attribute(:dat, 1.days.ago)
    assert_equal coupon.allow_send_checkin?(user._id.to_s), false
    CouponDown.last.use(user.id, nil)
    assert_equal coupon.allow_send_checkin?(user._id.to_s), true
  end



  
end
