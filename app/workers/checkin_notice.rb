# encoding: utf-8

class CheckinNotice
  @queue = :normal

  def self.perform(ck,new_shop,ssid=nil)
    #ck = {"_id"=>"51ebe5b220f318cd09000001", "acc"=>148.0, "alt"=>29.476196, "altacc"=>13, "bssid"=>"0:23:89:71:6f:c4", "city"=>"0571", "del"=>nil, "ip"=>"58.100.88.46", "loc"=>[30.279665, 120.108536], "od"=>20, "photos"=>nil, "sex"=>1, "sid"=>21828775, "speed"=>nil, "uid"=>"502e6303421aa918ba000001"}
    if ck.class == Hash #通过resque异步执行
      ck.keys.each {|key| ck.delete(key) if ck[key].nil?}
      checkin = Checkin.new(ck)
    else 
      checkin = ck #测试时直接调用
    end
    shop = Shop.find_by_id(checkin.sid)
    user = User.find_by_id(checkin.uid)
    if new_shop
      shop = Shop.find_primary(checkin.sid) if shop.nil?
      new_shop_welcome(user,shop,checkin)
    else
      send_all_notice_msg(user,shop)
    end
    if new_shop
      checkin.save!
      send_welcome_msg_if_not_invisible(user,shop)
      user.write_lat_loc(checkin, shop.name)
      CheckinBssidStat.insert_checkin(checkin, ssid) if checkin.bssid && !checkin.del
      return
    end
    send_coupon_msg = shop.send_coupon(checkin.uid)
    @send_coupon_msg = send_coupon_msg if ENV["RAILS_ENV"] == "test"
    if user.is_shop?
      send_welcome_msg_if_not_invisible(user,shop)
      return
    end
    if checkin.add_to_redis #当天首次签到
      checkin.save!
      #听.说 发送默认信息
      send_welcome_msg_if_not_invisible(user,shop)
      tingshuo_default_answer_text(shop, checkin.uid)
      user.write_lat_loc(checkin, shop.name)
      unless Os.overload?(0.8)
        fake_user(user,shop)
        CheckinBssidStat.insert_checkin(checkin, ssid) if checkin.bssid && !checkin.del
      end
      checkin.add_city_redis
      Resque.enqueue(LocationNotice, checkin.uid, checkin.sid )
    end    
    send_test_coupon(checkin.uid, checkin.sid)
  end

  def self.send_welcome_msg_if_not_invisible(user,shop)
    return if user.invisible==2
    return user.name if ENV["RAILS_ENV"] != "production"
    if user.gender.to_i==2
      message = "#{user.name} 来了~😊"
    else
      message = "#{user.name} 来啦~😝"
    end
    Resque.enqueue(XmppRoomMsg2, shop.id, user.id, message)
  end
  
  def self.send_test_coupon(uid,sid) #每次进入脸脸茶坊，都发送优惠券，方便客户端测试
    if sid==$llcf.to_s
      c = Coupon.find_by_id("5170b35820f318bbab00000c")
      c.send_coupon(uid) if c
      Resque.enqueue(XmppNotice, sid,uid, "恭喜！收到1张优惠券: #{c.name}, 马上领取吧！","coupon#{Time.now.to_i}")
    end
  end
  
  def self.fake_user(user,shop)
    last_loc = user.last_loc
    if shop.utotal<2 && (last_loc.nil? ||  (Time.now.to_i - last_loc[0]) > 3600*24 )
      fuser = User.fake_user(user)
      return unless fuser
      Xmpp.send_gchat2(fuser.id, shop.id, user.id, "#{fuser.name} 来了~😊")
    end
  end
  
  def self.new_shop_welcome(user,shop,checkin)
    str = "欢迎！您是第1个来到#{shop.name}的脸脸。置顶的照片栏还没被占领，赶快抢占并分享到微博/QQ空间吧。"
    Resque.enqueue(XmppNotice, shop.id, user.id, str)
    Resque.enqueue(XmppRoomMsg, $dduid, shop.id, user.id, "等#{shop.name}审核通过后，你就是这里的地主啦！👍")
  end
  
  def self.send_notice_if_exist(user,shop)
    notice = shop.notice
    return if notice.nil? || notice.title.nil? || notice.title.length<1
    return notice.title if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, shop.id, user.id, notice.title)
  end
  
  def self.send_share_coupon_notice_if_exist(user,shop)
    coupon = shop.share_coupon
    return if coupon.nil?
    return coupon.share_text_hint if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice,shop.id, user.id, coupon.share_text_hint)
    return true
  end

  def self.send_faq_notice_if_exist(user,shop)
    #return if shop.faqs.count<1
    text = shop.answer_text_default
    return if text=="本地点未启用数字问答系统"
    return if text[0,10]=="这地方怎么找不到人啊" && (Time.now.to_i-user.cati>7200) && user.checkins.count>1
    return text if ENV["RAILS_ENV"] != "production"
    Xmpp.send_gchat2($gfuid,shop.id, user.id, text)
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

  def self.tingshuo_default_answer_text(shop, uid)
    if shop.id.to_i == 21832930
      ttext = shop.answer_text('01')
      Xmpp.send_gchat2($gfuid,shop.id, uid, ttext) if ttext
    end
  rescue
    nil
  end
  
end
