# coding: utf-8

class ApiCouponController < ApplicationController
  
  layout nil

  def send
    @id = params[:id]
    @name = params[:name]
  end
  
  def do_send
    user = User.find_by_id(params[:uid])
    Coupon.last.send_coupon(user.id)
  end
  
end
