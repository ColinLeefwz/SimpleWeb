# coding: utf-8

class CheckinsController < ApplicationController
  before_filter :user_login_filter

  def create
    raise "user != session user" if params[:user_id].to_s != session[:user_id].to_s
    ck = do_checkin
    render :json => ck.to_json
  end

  def new_shop
    shop = Shop.new
    shop._id = Shop.next_id
    shop.name = params[:sname]
    shop.lo = [params[:lat].to_f, params[:lng].to_f]
    shop.city = shop.get_city
    shop.type = "用户添加"
    shop.save!
    params[:shop_id] = shop._id
    do_checkin
    render :json => shop.safe_output.to_json
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
  
  def do_checkin
    checkin = Checkin.new
    checkin.loc = [params[:lat].to_f, params[:lng].to_f]
    checkin.acc = params[:accuracy]
    checkin.uid = session[:user_id]
    checkin.sex = session_user.gender
    checkin.sid = params[:shop_id]
    checkin.od = params[:od]
    checkin.bssid = params[:bssid] if params[:bssid]
    if params[:altitude]
      checkin.alt = params[:altitude].to_f
      checkin.altacc = params[:altacc]
    end
    checkin.ip = real_ip
    send_if_first
    checkin.save!
    if checkin.add_to_redis #当天首次签到
      send_welcome_msg_if_not_invisible(session_user.gender,session_user.name)
      send_coupon_if_exist
    end
    send_notice_if_exist
    checkin
  end

  def send_welcome_msg_if_not_invisible(user_gender, user_name)
    return if session_user.invisible==2
    Resque.enqueue(XmppWelcome, params[:shop_id], user_gender, params[:user_id], user_name)
  end
  
  def send_notice_if_exist
    shop = Shop.find(params[:shop_id])
    return if shop.nil?
    notice = shop.notice
    return if notice.nil? || notice.title.nil? || notice.title.length<1
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], notice.title)
  end
  
  def send_if_first
    shop = Shop.find(params[:shop_id])
    return if shop.nil?
    return if Checkin.where({sid: params[:shop_id]}).first
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], 
      "欢迎！您是第一个来到\##{shop.name}\#的脸脸，很特别哦。等有其他人加入后，你们就可以聊天了。")
  end 

  def send_coupon_if_exist
    if ENV["RAILS_ENV"] == "production"
      Resque.enqueue(SendCoupon, session[:user_id], params[:shop_id])
    else
      Shop.find(params[:shop_id]).send_coupon(session[:user_id])
    end
  end


end
