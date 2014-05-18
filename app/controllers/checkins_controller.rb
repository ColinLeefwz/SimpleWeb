# coding: utf-8

class CheckinsController < ApplicationController
  before_filter :user_login_filter

  def create
    raise "user != session user" if params[:user_id].to_s != session[:user_id].to_s
    do_checkin
    render :json => {ok:1}.to_json
  end
  
  def new_shop
    if params[:sname].length<3
      render :json => {error: "地点名称不能少于三个字"}.to_json
      return
    end
    if params[:accuracy].to_i==0 || params[:accuracy].to_i > 1000
      str = "手机当前定位误差大于1000米，不能创建地点。"
      str += "使用wifi可以提高定位精度" if params[:bssid]
      render :json => {error: str}.to_json
      return
    end
    if params[:sname][0,3]=="@@@"
      render :json => {error: "没权限创建：#{params[:sname]}"}.to_json
      return
    end
    if !session_user.is_kx_or_co?
      if Rails.cache.read("ADDSHOP#{session[:user_id]}")
        render :json => {error: "一个用户一天只能创建一个地点"}.to_json
        return
      end
    end
    shop = gen_new_shop
    if is_session_user_kx
      score = 75
    else
      score = 68
    end
    if Shop.has_similar_shop?(shop,score)
      render :json => {error: "已经存在雷同的地点，不能重复创建"}.to_json
      return
    end
    shop.save!
    Rails.cache.write("ADDSHOP#{session[:user_id]}", 1, :expires_in => 24.hours)
    params[:shop_id] = shop.id
    do_checkin(shop,false,true)
    render :json => shop.safe_output.to_json
  end
  
  
  def delete
    begin
      cin = Checkin.find(params[:id])
    rescue
      Xmpp.error_notify("#{session_user.name}:试图删除不存在的签到:#{params[:id]}")
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
    shop.name = params[:sname].strip
    shop.lo = [params[:lat].to_f, params[:lng].to_f]
    shop.lo = Shop.lob_to_lo(shop.lo) if params[:baidu]
    shop.city = shop.get_city
    shop.t = params[:t].to_i
    shop.addr = params[:addr] if params[:addr]
    shop.tel = params[:tel] if params[:tel]
    shop.large = true if params[:large].to_i==1
    shop.d = 10  if !session_user.is_kx_or_co?
    shop.creator = session[:user_id]
    shop.utype = params[:type] if params[:type]
    shop
  end
  
  def do_checkin(shop=nil,fake=false, new_shop=false)
    shop = Shop.find_by_id(params[:shop_id]) if shop.nil?
    checkin = Checkin.new
    checkin.loc = [params[:lat].to_f, params[:lng].to_f]
    checkin.loc = Shop.lob_to_lo(checkin.loc) if params[:baidu]
    checkin.acc = params[:accuracy]
    checkin.uid = session[:user_id]
    checkin.sex = session_user.gender
    checkin.sid = shop.id
    if shop && shop.city
      checkin.city = shop.city 
    else
      checkin.city = Shop.get_city(checkin.loc)
    end
    checkin.od = params[:od]
    checkin.bd = params[:baidu] if params[:baidu]
    checkin.bssid = params[:bssid] if params[:bssid] && !fake
    if params[:altitude]
      checkin.alt = params[:altitude].to_f
      checkin.altacc = params[:altacc]
    end
    if params[:speed]
      speed = params[:speed].to_f 
      checkin.speed = speed if speed>0.1
    end
    checkin.del = true if fake
    checkin.del = true if checkin.acc==5 && checkin.alt==0
    checkin.ip = real_ip
    new_user_nofity(checkin)
    CheckinsController.send_all_notice_msg(checkin.user,checkin.shop)
    if Rails.env != "test"
      Resque.enqueue(CheckinNotice, checkin, new_shop, params[:ssid] )
    else
      CheckinNotice.perform(checkin, new_shop, params[:ssid])
    end
    checkin
  end

  def new_user_nofity(checkin)
    if session[:new_user_flag]
      session[:new_user_flag] = nil
      session_user.update_attribute(:city, checkin.city)
      return  if ENV["RAILS_ENV"] != "production"
      Resque.enqueue(NewUser, checkin.uid,checkin.sid,checkin.od) unless checkin.shop.group_id
    end
  end
  

  def self.send_notice_if_exist(user,shop)
    notice = shop.notice
    return if notice.nil?
    if (photo=notice.photo)
      Resque.enqueue(XmppRoomMsg,photo.user_id,shop.id, user.id, "[img:#{photo._id}]#{photo.desc}")
    elsif(faq=notice.faq)
      faq.send_to_room(user.id)
    else
      return if notice.title.blank?
      Resque.enqueue(XmppNotice, shop.id, user.id, notice.title)
    end
  end
  
  def self.send_share_coupon_notice_if_exist(user,shop)
    coupon = shop.share_coupon
    return if coupon.nil?
    return coupon.share_text_hint if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice,shop.id, user.id, coupon.share_text_hint)
    return true
  end

  def self.send_faq_notice_if_exist(user,shop)
    return if shop.has_menu.to_i>0 #有自定义菜单的地点不推送问答的列表
    #return if shop.faqs.count<1
    text = shop.faqs_text(user)
    return if text=="本地点未启用数字问答系统"
    return if text[0,10]=="这地方怎么找不到人啊" && (Time.now.to_i-user.cati>7200) && user.checkins.count>1
    return text if ENV["RAILS_ENV"] != "production"
    Xmpp.send_gchat2(shop.msg_sender,shop.id, user.id, text)
    return true
  end
    
  def self.send_all_notice_msg(user,shop)
    return if shop.nil?
    send_notice_if_exist user, shop
    flag1 = send_share_coupon_notice_if_exist(user,shop)
    flag2 = send_faq_notice_if_exist(user,shop)
    return if flag1 || flag2
    #order = shop.realtime_user_count+1
    #str = ""
    #str += "欢迎！您是第 #{order} 个来到\##{shop.name}\#的脸脸。" if order<=10
    #str += "置顶的照片栏还没被占领，赶快抢占并分享到微博/QQ空间吧。" if shop.photo_count<4
    #return str if ENV["RAILS_ENV"] != "production"
    #Resque.enqueue(XmppNotice, params[:shop_id], params[:user_id], str) if str.length>0 
  end 
  

end
