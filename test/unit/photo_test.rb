# coding: utf-8
require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    Photo.delete_all
    reload('coupons.js')
  end

  test "#send_coupon 分享优惠券, 没匹配关键字不发送。" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享'})
    assert_equal photo.send_coupon, nil
  end

  test "#send_coupon 分享优惠券, 匹配关键字发送。" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    assert_match '优惠券:测试分享优惠券:测试1:507fc5bfc9ad42d756a412e5', photo.send_coupon
  end

  test "#send_coupon 分享优惠券, 优惠券关键字是空，发送。" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    photo.shop.share_coupon.unset(:text)
    assert_match '优惠券:测试分享优惠券:测试1:507fc5bfc9ad42d756a412e5', photo.send_coupon
  end

  test "#send_coupon 每天只能发送一次" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e5')
    assert_match '优惠券:测试分享优惠券:测试1:507fc5bfc9ad42d756a412e5', photo.send_coupon
    coupon.download(User.first.id)
    assert_equal photo.send_coupon, nil
  end


  
end
