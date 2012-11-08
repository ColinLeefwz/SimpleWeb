# coding: utf-8

class CheckinsController < ApplicationController

  def create
    raise "user != session user" if params[:user_id].to_s != session[:user_id].to_s
    send_welcome_msg_if_not_invisible(session_user.gender)
    checkin = Checkin.new
    checkin.loc = [params[:lat].to_f, params[:lng].to_f]
    checkin.acc = params[:accuracy]
    checkin.uid = Moped::BSON::ObjectId(params[:user_id]) 
    checkin.sex = session_user.gender
    checkin.sid = params[:shop_id]
    checkin.od = params[:od]
    if params[:altitude]
      checkin.alt = params[:altitude].to_f
      checkin.altacc = params[:altacc]
    end
    checkin.ip = real_ip
    checkin.save!
    checkin.add_to_redis
    send_coupon_if_exist
    render :json => checkin.to_json
  end

  private

  def send_welcome_msg_if_not_invisible(user_gender)
    return if session_user.invisible==2
    Resque.enqueue(XmppWelcome, params[:shop_id], user_gender, params[:user_id])
  end

  def send_coupon_if_exist
    # shop.send_coupon
    coupon = Coupon.where({shop_id:params[:shop_id]}).last
    coupon = Coupon.gen_demo(params[:shop_id]) if coupon.nil?
    coupon.send_coupon(session[:user_id]) if coupon
  end





end
