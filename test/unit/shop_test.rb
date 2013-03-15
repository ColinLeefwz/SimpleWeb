# coding: utf-8
require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    reload('checkins.js')
    reload('shops.js')
    reload('coupons.js')
    reload('shop_faqs.js')
  end


  test ".find_by_id 不存在的id返回nil" do
    {:a => "\360\237\230\204"}.to_json.to_s == "{\"a\":\"😄\"}"
    {:a => "\360\237\230\204"}.to_json == "{\"a\":\"😄\"}"
    assert_equal Shop.find_by_id('12345'), nil
  end
  
  test ".find_by_id 存在的id 能正确的查询" do
    assert_equal Shop.find_by_id('1').name, '测试1'
  end

  test "#send_coupon(user_id) 新用户当天第一次签到，发送每日签到优惠，每日前几名签到优惠，新用户首次签到优惠，子商家只收到每日签到优惠.第二次签到没有" do
    $redis.keys("ckin*").each{|key| $redis.zremrangebyrank(key, 0, -1)}
    user = User.find('502e6303421aa918ba000005')
    shop = Shop.find(1)
    checkin1 = Checkin.create!(uid: user._id, sid: shop.id)
    assert_match(/收到4张优惠券: 测试首次优惠券,测试前2名优惠券,测试每日优惠券.,测试每日优惠券2./, shop.send_coupon(user.id))
    checkin1.add_to_redis
    checkin2 = Checkin.create!(uid: user._id, sid: shop.id)
    assert_equal shop.send_coupon(user.id), nil
  end

  test "#send_coupon(user_id) 老用户当天第一次签到，发送每日签到优惠，每日前几名签到优惠，子商家只收到每日签到优惠.第二次签到没有" do
    $redis.keys("ckin*").each{|key| $redis.zremrangebyrank(key, 0, -1)}
    user = User.find('502e6303421aa918ba00007c')
    shop = Shop.find(1)
    checkin1 = Checkin.create!(uid: user._id, sid: shop.id)
    assert_match(/收到3张优惠券: 测试前2名优惠券,测试每日优惠券.,测试每日优惠券2./, shop.send_coupon(user.id))
    checkin1.add_to_redis
    checkin2 = Checkin.create!(uid: user._id, sid: shop.id)
    assert_equal shop.send_coupon(user.id), nil
  end

  test "#send_coupon(user_id) 老用户当天第一次满累计签到三天，累计签到3次，发送每日签到优惠，每日前几名签到优惠，子商家只收到每日签到优惠.第二次签到没有" do
    $redis.keys("ckin*").each{|key| $redis.zremrangebyrank(key, 0, -1)}
    user = User.find('502e6303421aa918ba000002')
    shop = Shop.find(1)
    checkin1 = Checkin.create!(uid: user._id, sid: shop.id)
    assert_match(/收到4张优惠券: 测试累计优惠券,测试前2名优惠券,测试每日优惠券.,测试每日优惠券2./, shop.send_coupon(user.id))
    checkin1.add_to_redis
    checkin2 = Checkin.create!(uid: user._id, sid: shop.id)
    assert_equal shop.send_coupon(user.id), nil
  end

  test "#answer_text(msg) 回复0" do
    shop = Shop.find(1)
    assert_equal shop.answer_text('0'), "试试回复：\n01=>问题1.\n02=>问题2.\n03=>问题3.\n04=>问题4.\n05=>问题5."
  end
  
  test "#answer_text(msg) 回复01" do
    shop = Shop.find(1)
    assert_equal shop.answer_text('01'), "答案1"
  end

  test "#answer_text(msg) 回复06" do
    shop = Shop.find(1)
    assert_equal shop.answer_text('06'), "试试回复：\n01=>问题1.\n02=>问题2.\n03=>问题3.\n04=>问题4.\n05=>问题5."
  end

  test "#answer_text(msg) 回复s" do
    shop = Shop.find(1)
    assert_equal shop.answer_text('s'), nil
  end

  test "#answer_text(msg) 没开通问答系统回复0" do
    shop = Shop.find(2)
    assert_equal shop.answer_text('0'), "本地点未启用数字问答系统"
  end
  
end

