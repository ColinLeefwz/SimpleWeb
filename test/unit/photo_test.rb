# coding: utf-8
require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    Photo.delete_all
    CouponDown.delete_all
    reload('coupons.js')
  end

  test "#send_coupon 分享优惠券, 没匹配关键字不发送。" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '不一样'})
    assert_equal photo.send_coupon, nil
  end

  test "#send_coupon 分享优惠券, 部分匹配关键字发送。" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '分享'})
    message = photo.send_coupon
    assert_equal "恭喜樱桃红了！收到1张分享优惠券: 测试分享优惠券,马上领取吧！", message
  end
  
  test "#send_coupon 分享优惠券, 匹配关键字发送。" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    message = photo.send_coupon
    assert_equal "恭喜樱桃红了！收到1张分享优惠券: 测试分享优惠券,马上领取吧！", message
  end

  test "#send_coupon 分享优惠券, 优惠券关键字是空，发送。" do
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    photo.shop.share_coupon.unset(:text)
    message = photo.send_coupon
    assert_equal "恭喜樱桃红了！收到1张分享优惠券: 测试分享优惠券,马上领取吧！", message
  end

  test "#send_coupon 每天只能发送一次" do
    #分享类优惠券只能一张有效，删除‘首次分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e6').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e5')
    CouponDown.delete_all
    CouponDown.create!(:cid => coupon.id, :uid => User.first.id, :dat => 1.days.ago)
    message = photo.send_coupon
    assert_equal "恭喜樱桃红了！收到1张分享优惠券: 测试分享优惠券,马上领取吧！", message
    assert_equal photo.send_coupon, nil
    photo1 = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    assert_equal photo1.send_coupon, nil
  end

  test "#send_coupon 首次分享发送,发送过就不发送" do
    #分享类优惠券只能一张有效，删除‘每日分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e5').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e6')
    CouponDown.delete_all
    CouponDown.create!(:cid => coupon.id, :uid => User.first.id, :dat => 1.days.ago)
    assert_equal photo.send_coupon, nil
  end

  test "#send_pshop_coupon 分店分享， 发送总店每日分享优惠券 " do
    #分享类优惠券只能一张有效，删除‘首次分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e6').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 111, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e5')
    CouponDown.delete_all
    message = photo.send_pshop_coupon
    assert_equal ["测试分享优惠券"], message
    assert CouponDown.last.dat.to_date == Time.now.to_date && CouponDown.last.d_sid.to_i == 111
    #TODO：上面的代码在凌晨执行会失败
    assert_equal photo.send_coupon, nil
    CouponDown.last.update_attribute(:dat, 1.days.ago )
    message = photo.send_pshop_coupon
    assert_equal ["测试分享优惠券"],message
    assert_equal CouponDown.where({cid: '507fc5bfc9ad42d756a412e5', d_sid: 111}).to_a.length, 2
    assert_equal photo.send_coupon, nil
    photo1 = Photo.create!({:user_id => User.first.id, :room => 111, :desc => '我们一起分享吧'})
    assert_equal photo1.send_coupon, nil
  end

  test "#send_pshop_coupon 分店分享， 发送总店首次分享优惠券 " do
    #分享类优惠券只能一张有效，删除‘每日分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e5').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 111, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e6')
    CouponDown.delete_all
    message = photo.send_pshop_coupon
    assert_equal ["测试分享优惠券"], message
    assert CouponDown.last.dat.to_date == Time.now.to_date && CouponDown.last.d_sid.to_i == 111
    assert_equal photo.send_coupon, nil
    CouponDown.create!(cid: '507fc5bfc9ad42d756a412e6', uid: User.first.id, dat: 1.days.ago, d_sid: 111 )
    assert_equal photo.send_coupon, nil
  end


  
end
