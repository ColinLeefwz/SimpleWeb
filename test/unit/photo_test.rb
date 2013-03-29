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
    #分享类优惠券只能一张有效，删除‘首次分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e6').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e5')
    coupon.unset(:users)
    coupon.add_to_set(:users, {"id" => User.first.id, "dat" => 1.days.ago})
    assert_match '优惠券:测试分享优惠券:测试1:507fc5bfc9ad42d756a412e5', photo.send_coupon
    assert_equal photo.send_coupon, nil
    photo1 = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    assert_equal photo1.send_coupon, nil
  end

  test "#send_coupon 首次分享发送,发送过就不发送" do
    #分享类优惠券只能一张有效，删除‘每日分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e5').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 1, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e6')
    coupon.unset(:users)
    coupon.add_to_set(:users, {"id" => User.first.id, "dat" => 1.days.ago})
    assert_equal photo.send_coupon, nil
  end

  test "#send_pshop_coupon 分店分享， 发送总店每日分享优惠券 " do
    #分享类优惠券只能一张有效，删除‘首次分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e6').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 111, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e5')
    coupon.unset(:users)
    assert_match '优惠券:测试分享优惠券:测试1:507fc5bfc9ad42d756a412e5', photo.send_pshop_coupon
    assert Coupon.find('507fc5bfc9ad42d756a412e5').users.detect{|u| u['dat'].to_date == Time.now.to_date && u['sid'].to_i == 111}
    assert_equal photo.send_coupon, nil
    coupon = Coupon.find('507fc5bfc9ad42d756a412e5')
    coupon.users.first['dat'] = 1.days.ago
    coupon.save
    assert_match '优惠券:测试分享优惠券:测试1:507fc5bfc9ad42d756a412e5', photo.send_pshop_coupon
    assert_equal Coupon.find('507fc5bfc9ad42d756a412e5').users.select{|u| u['sid'].to_i==111}.count, 2
    assert_equal photo.send_coupon, nil
    photo1 = Photo.create!({:user_id => User.first.id, :room => 111, :desc => '我们一起分享吧'})
    assert_equal photo1.send_coupon, nil
  end

  test "#send_pshop_coupon 分店分享， 发送总店首次分享优惠券 " do
    #分享类优惠券只能一张有效，删除‘每日分享’规则的优惠券
    Coupon.find('507fc5bfc9ad42d756a412e5').delete
    photo = Photo.create!({:user_id => User.first.id, :room => 111, :desc => '我们一起分享吧'})
    coupon = Coupon.find('507fc5bfc9ad42d756a412e6')
    coupon.unset(:users)
    assert_match '优惠券:测试分享优惠券:测试1:507fc5bfc9ad42d756a412e6', photo.send_pshop_coupon
    assert Coupon.find('507fc5bfc9ad42d756a412e6').users.detect{|u| u['dat'].to_date == Time.now.to_date && u['sid'].to_i == 111}
    assert_equal photo.send_coupon, nil
    coupon = Coupon.find('507fc5bfc9ad42d756a412e6')
    coupon.unset(:users)
    coupon.add_to_set(:users, {"id" => User.first.id, "dat" => 1.days.ago, 'sid' => 111})
    assert_equal photo.send_coupon, nil
  end


  
end
