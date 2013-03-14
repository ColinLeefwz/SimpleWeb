# coding: utf-8
require 'test_helper'

class CouponTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    reload('coupons.js')
    reload('checkins.js')
    $redis.keys("ckin*").each{|key| $redis.zremrangebyrank(key, 0, -1)}
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
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    checkin1 = Checkin.create!(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id.to_s), true
    checkin1.add_to_redis
    assert_equal coupon.allow_send_checkin?('502e6303421aa918ba000005'), nil
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
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
  end

  test "#allow_send_checkin? 规则是累计签到三天， 第三天签到才可以发优惠券。超过部分不发" do
    user = User.find('502e6303421aa918ba000005')
    coupon = Coupon.find('507fc5bfc9ad42d756a412e4')
    #添加一个当前之前的签到
    Checkin.mongo_session['checkins'].insert(_id: "502e6303421aa918ba00007c".__mongoize_object_id__,uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
    Checkin.mongo_session['checkins'].insert(_id: "502d6303421aa918ba00007c".__mongoize_object_id__,uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
    Checkin.mongo_session['checkins'].insert(_id: "502d6303421aa918ba000071".__mongoize_object_id__,uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
    Checkin.create(uid: user._id, sid: coupon.shop_id)
    assert_equal coupon.allow_send_checkin?(user._id), true
    #优惠券只能下载一个
    coupon.download(user.id)
    assert_equal coupon.allow_send_checkin?(user._id), nil
  end
  
end
