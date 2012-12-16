# coding: utf-8

class CheckinsController < ApplicationController
  before_filter :user_login_filter

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
    send_notice_if_exist
    send_coupon_if_exist
    render :json => checkin.to_json
  end

  def delete
    begin
      cin = Checkin.find(params[:id])
    rescue
      error_log "\nTry to delete non-exist checkin:#{params[:id]}, #{Time.now}"
      render :json => {:deleted => params[:id]}.to_json
      return
    end

    if cin.uid != session[:user_id]
      render :json => {:error => "checkin's owner #{cin.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    if cin.update_attribute(:del,true)
      render :json => {:deleted => params[:id]}.to_json
    else
      render :json => {:error => "cin #{params[:id]} delete failed"}.to_json
    end
  end



  private

  def send_welcome_msg_if_not_invisible(user_gender)
    return if session_user.invisible==2
    Resque.enqueue(XmppWelcome, params[:shop_id], user_gender, params[:user_id])
  end
  
  def send_notice_if_exist
    shop = Shop.find(params[:shop_id])
    return if shop.nil?
    notice = shop.notice
    return if notice.nil? || notice.title.nil? || notice.title.length<1
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], notice.title)
  end

  def send_coupon_if_exist
    if ENV["RAILS_ENV"] == "production"
      Resque.enqueue(SendCoupon, session[:user_id], params[:shop_id])
    else
      Shop.find(params[:shop_id]).send_coupon(session[:user_id])
    end
  end


end
