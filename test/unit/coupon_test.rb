# coding: utf-8
require 'test_helper'

class CouponTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    reload('coupons.js')
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



  test ".allow_send? 优惠券规则只能下载一次,第一次下载" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 0
    assert coupon.allow_send?(user.id)
  end

  test ".allow_send? 优惠券规则只能下载一次,第二次下载" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e1')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 0
    coupon.download(user.id)
    assert !coupon.allow_send?(user.id)
  end

  test ".allow_send? 优惠券规则只能有一个未使用,第一次下载" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e2')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 1
    assert coupon.allow_send?(user.id)
  end

  test ".allow_send? 优惠券规则只能有一个未使用,未使用下载" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e2')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 1
    coupon.download(user.id)
    assert !coupon.allow_send?(user.id)
  end
  
  test ".allow_send? 优惠券规则只能有一个未使用,使用后下载。" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e2')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 1
    coupon.download(user.id)
    coupon.use(user.id)
    assert coupon.allow_send?(user.id)
  end

  test ".allow_send? 优惠券规则无限制下载, 第一下载。" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e3')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 2
    assert coupon.allow_send?(user.id)
  end
  
  test ".allow_send? 优惠券规则无限制下载, 未使用下载。" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e3')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 2
    coupon.download(user.id)
    assert coupon.allow_send?(user.id)
  end

  test ".allow_send? 优惠券规则无限制下载, 使用后下载。" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e3')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 2
    coupon.download(user.id)
    coupon.use(user.id)
    assert coupon.allow_send?(user.id)
  end

  test ".allow_send? 优惠券规则无限制下载, 多次下载使用后下载。" do
    coupon = Coupon.find('507fc5bfc9ad42d756a412e3')
    user = User.find('502e6303421aa918ba000005')
    assert coupon.rule.to_i == 2
    coupon.download(user.id)
    coupon.use(user.id)
    coupon.download(user.id)
    coupon.use(user.id)
    coupon.download(user.id)
    coupon.download(user.id)
    assert coupon.allow_send?(user.id)
  end


end
