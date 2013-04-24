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
    if params[:sname][0,3]=="@@@" #测试人员输入商家id模拟签到
      shop = Shop.find_by_id(params[:sname][3..-1])
      if shop.nil? 
        render :json => {error: "地点不存在：params[:sname][3..-1]"}.to_json
        return
      end      
      if session[:user_id].to_s != shop.seller_id.to_s && !is_session_user_kx
        render :json => {error: "没权限创建：params[:sname]"}.to_json
        return
      end
      params[:shop_id] = shop.id
      params[:bssid] = nil
      do_checkin(shop,true)
      render :json => shop.safe_output.to_json
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
    do_checkin(shop,false,true)
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
  
  def do_checkin(shop=nil,fake=false, new_shop=false)
    shop = Shop.find_by_id(params[:shop_id]) if shop.nil?
    checkin = Checkin.new
    checkin.loc = [params[:lat].to_f, params[:lng].to_f]
    checkin.acc = params[:accuracy]
    checkin.uid = session[:user_id]
    checkin.sex = session_user.gender
    checkin.sid = shop.id
    checkin.city = shop.city if shop
    checkin.od = params[:od]
    checkin.bssid = params[:bssid] if params[:bssid] && !fake
    if params[:altitude]
      checkin.alt = params[:altitude].to_f
      checkin.altacc = params[:altacc]
    end
    if params[:speed]
      speed = params[:speed].to_f 
      checkin.speed = speed if speed>0.5
    end
    checkin.del = true if fake
    checkin.del = true if checkin.acc==5 && checkin.alt==0
    checkin.ip = real_ip
    send_all_notice_msg shop
    checkin.save!
    session_user.write_lat_loc(checkin, shop.name)
    if new_shop
      str = "欢迎！您是第1个来到#{shop.name}的脸脸。置顶的照片栏还没被占领，赶快抢占并分享到微博/QQ空间吧。"
      Resque.enqueue(XmppNotice, shop.id, params[:user_id], str)
      Resque.enqueue(XmppRoomMsg, $gfuid, shop.id, params[:user_id], "等#{shop.name}审核通过后，你就是这里的地主啦！👍")
      send_welcome_msg_if_not_invisible(session_user.gender,session_user.name)
      new_user_nofity(checkin)
      CheckinBssidStat.insert_checkin(checkin, params[:ssid]) if params[:bssid] && !checkin.del
      return checkin
    end
    send_coupon_msg = shop.send_coupon(session[:user_id])
    @send_coupon_msg = send_coupon_msg if ENV["RAILS_ENV"] == "test"
    CheckinBssidStat.insert_checkin(checkin, params[:ssid]) if params[:bssid] && !checkin.del
    if checkin.add_to_redis #当天首次签到
      if shop.utotal<1 || ( shop.utotal<2 && (Time.now.to_i-User.last.cati)<3600*24*7 )
        fuser = User.fake_user(session_user)
        Xmpp.send_gchat2(fuser.id, params[:shop_id], session[:user_id], "#{fuser.name} 来了~😊") if fuser
      end
      send_welcome_msg_if_not_invisible(session_user.gender,session_user.name)
    end    
    checkin.add_city_redis
    new_user_nofity(checkin)
    Coupon.find("5170b35820f318bbab00000c").send_coupon(params[:user_id]) if params[:shop_id]==$llcf.to_s
    checkin
  end
  
  def new_user_nofity(checkin)
    if session[:new_user_flag]
      session[:new_user_flag] = nil
      session_user.update_attribute(:city, checkin.city)
      return  if ENV["RAILS_ENV"] != "production"
      Resque.enqueue(NewUser, checkin.uid,checkin.sid,checkin.od)
    end
  end

  def send_welcome_msg_if_not_invisible(user_gender, user_name)
    return if session_user.invisible==2
    return user_name if ENV["RAILS_ENV"] != "production"
    if user_gender.to_i==2
      message = "#{user_name} 来了~😊"
    else
      message = "#{user_name} 来啦~😝"
    end
    Resque.enqueue(XmppRoomMsg2, params[:shop_id], params[:user_id], message)
  end
  
  def send_notice_if_exist(shop)
    notice = shop.notice
    return if notice.nil? || notice.title.nil? || notice.title.length<1
    return notice.title if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], notice.title)
  end
  
  def send_share_coupon_notice_if_exist(shop)
    coupon = shop.share_coupon
    return if coupon.nil?
    return coupon.share_text_hint if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], coupon.share_text_hint)
    return true
  end

  def send_faq_notice_if_exist(shop)
    #return if shop.faqs.count<1
    #Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], "本地点开启了数字问答系统，请发送数字0获知详情。")
    text = shop.answer_text_default
    return if text=="本地点未启用数字问答系统"
    return text if ENV["RAILS_ENV"] != "production"
    Xmpp.send_gchat2($gfuid,params[:shop_id], params[:user_id], text)
    return true
  end
    
  def send_all_notice_msg(shop)
    return if shop.nil?
    send_notice_if_exist shop
    flag1 = send_share_coupon_notice_if_exist(shop)
    flag2 = send_faq_notice_if_exist(shop)
    return if flag1 || flag2
    order = shop.realtime_user_count+1
    str = ""
    #str += "欢迎！您是第 #{order} 个来到\##{shop.name}\#的脸脸。" if order<=10
    str += "置顶的照片栏还没被占领，赶快抢占并分享到微博/QQ空间吧。" if shop.photo_count<4
    return str if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], str) if str.length>0 
  end 


end
