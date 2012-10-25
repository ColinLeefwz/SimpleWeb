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
    if user_gender==2
      message = "Hi，我来了~😊"
    else
      message = "Hi，我来啦~😝"
    end
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => params[:shop_id].to_s , :message=> message ,
        :uid => params[:user_id].to_s)  {|response, request, result| puts response }
    #TODO: 处理rest调用出错和重试
    #TODO: 消息持久化。目前是直接投递的，导致没有保存。
  end

  def send_coupon_if_exist
    coupon = Coupon.where({shop_id:params[:shop_id]}).last
    coupon = Coupon.gen_demo(params[:shop_id]) if coupon.nil?
    coupon.send_coupon(session[:user_id]) if coupon
  end





end
