# coding: utf-8

class CheckinsController < ApplicationController
  before_filter :user_login_filter

  def create
    raise "user != session user" if params[:user_id].to_s != session[:user_id].to_s
    ck = do_checkin
    render :json => ck.to_json
  end

  def new_shop
    if params[:sname].length<4
      render :json => {error: "地点名称不能少于四个字"}.to_json
      return
    end
    shop = gen_new_shop
    ss = Shop.similar_shops(shop,70)
    if ss.length>0
      shop = ss[0]
    else
      shop.save!
    end
    params[:shop_id] = shop.id
    do_checkin(shop)
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
  
  def gen_new_shop
    shop = Shop.new
    shop._id = Shop.next_id
    shop.name = params[:sname]
    shop.lo = [params[:lat].to_f, params[:lng].to_f]
    shop.city = shop.get_city
    #shop.d = 10
    shop.creator = session[:user_id]
    shop
  end
  
  def do_checkin(shop=nil)
    shop = Shop.find(params[:shop_id]) if shop.nil?
    checkin = Checkin.new
    checkin.loc = [params[:lat].to_f, params[:lng].to_f]
    checkin.acc = params[:accuracy]
    checkin.uid = session[:user_id]
    checkin.sex = session_user.gender
    checkin.sid = shop.id
    checkin.city = shop.city if shop
    checkin.od = params[:od]
    checkin.bssid = params[:bssid] if params[:bssid]
    if params[:altitude]
      checkin.alt = params[:altitude].to_f
      checkin.altacc = params[:altacc]
    end
    checkin.ip = real_ip
    send_if_first shop
    checkin.save!
    CheckinBssidStat.insert_checkin(checkin) if params[:bssid]
    if checkin.add_to_redis #当天首次签到
      send_welcome_msg_if_not_invisible(session_user.gender,session_user.name)
    end
    send_notice_if_exist shop
    send_coupon_if_exist
    if session[:new_user_flag]
      session[:new_user_flag] = nil
      session_user.update_attribute(:city, checkin.city)
      Resque.enqueue(NewUser, checkin.uid,checkin.sid,checkin.od)
    end
    checkin
  end

  def send_welcome_msg_if_not_invisible(user_gender, user_name)
    return if session_user.invisible==2
    Resque.enqueue(XmppWelcome, params[:shop_id], user_gender, params[:user_id], user_name)
    Xmpp.send_gchat2($gfuid,params[:shop_id], params[:user_id],"新年快乐🎈🎈🎈")
  end
  
  def send_notice_if_exist(shop)
    return if shop.nil?
    notice = shop.notice
    return if notice.nil? || notice.title.nil? || notice.title.length<1
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], notice.title)
  end
  
  def send_if_first(shop)
    return if shop.nil?
    order = shop.realtime_user_count+1
    str = ""
    str += "欢迎！您是第 #{order} 个来到\##{shop.name}\#的脸脸。" if order<=10
    str += "置顶的照片栏还没被占领，赶快抢占并分享到微博吧。" if shop.photo_count<4
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], str) if str.length>0 
  end 

  def send_coupon_if_exist
    if ENV["RAILS_ENV"] == "production"
      Resque.enqueue(SendCoupon, session[:user_id], params[:shop_id])
    else
      Shop.find(params[:shop_id]).send_coupon(session[:user_id])
    end
  end


end
