# coding: utf-8

class ApiCouponController < ApplicationController
  
  layout nil

  def init_send
    @id = params[:id]
    @name = params[:name]
  end
  
  def do_send
    Rails.cache.fetch("APICOUPON#{params[:uidsid]}") do
      uid, sid = params[:uidsid][1..-2].split(",")
      user = User.find_by_id(uid)
      @coupon = Coupon.where({:shop_id => sid.to_i}).last
      @cpdown = @coupon.send_coupon(user.id)
    end
    unless @coupon
      return render :text => "你已经获得过优惠券了"
    end
  end
  
end
