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
      checkin.save!
      send_welcome_msg_if_not_invisible(user,shop)
      CheckinBssidStat.insert_checkin(checkin, ssid) if checkin.bssid && !checkin.del
      return
    end
    if user.is_shop?
      send_welcome_msg_if_not_invisible(user,shop)
      return
    end
    send_coupon_msg = shop.send_coupon(checkin.uid)
    @send_coupon_msg = send_coupon_msg if ENV["RAILS_ENV"] == "test"
    if checkin.add_to_redis #当天首次签到
      dis = checkin.distance_to_shop
      at_here = (dis<1000 || dis<checkin.acc)
      if at_here
        checkin.save!
      else
        if User.is_kx?(checkin.uid)
          checkin.save!
        elsif checkin.staff_checkin?
          # 商家员工（加V的用户）是随时可以摇入他管理的地点的。这里保证实际签到才保存，可用于考勤。
          Xmpp.error_notify("商家#{shop.name}的员工#{user.name}远距离签到")
        else
          #Xmpp.error_notify("#{user.name}超过#{dis}米，却在#{shop.name}签到")
          checkin.save!
        end
      end
      send_staff_welcome(user,shop)
      send_welcome_msg_if_not_invisible(user,shop)
      tingshuo_default_answer_text(shop, checkin.uid)
      unless Os.overload?(0.8)
        fake_user(user,shop)
        CheckinBssidStat.insert_checkin(checkin, ssid) if checkin.bssid && !checkin.del
      end
      checkin.add_city_redis
      Resque.enqueue(LocationNotice, checkin.uid, checkin.sid )
    end    
    send_test_coupon(checkin.uid, checkin.sid)
    send_test_mark(checkin.uid, checkin.sid)
  end

  #  #测试分店测试点评商家
  def self.send_test_mark(uid, sid)
    return if sid.to_i != $cezyfd
    url = "http://shop.dface.cn/shop3_marks/new?sid=#{sid}&uid=#{uid}"
    url = ShopFaq.short_url('2.00kfdvGCGFlsXC1b5e64ba39QaSfpB', url)
    Xmpp.send_gchat2($gfuid,sid,uid, '测试点评商家', nil, " NOLOG='1'  url='#{url}' " , "<x xmlns='dface.url'>#{url}</x>")
  rescue
    nil
  end


  def self.send_welcome_msg_if_not_invisible(user,shop)
    return if user.invisible==2
    return user.name if ENV["RAILS_ENV"] != "production"
    if user.gender.to_i==2
      message = "#{user.name} 来了~😊"
    else
      message = "#{user.name} 来啦~😝"
    end
    all = $redis.get("suac#{shop.id.to_i}")
    if all.nil? || all.to_i<5
      log = 1
    else
      log = 0
    end
    Resque.enqueue(XmppRoomMsg2, shop.id, user.id, message, "ckn#{$uuid.generate}", log)
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

  #每次如果有员工在加入的商家签到，在最新动态里欢迎提示
  def self.send_staff_welcome(user,shop)
    shop.staffs.each do |uid|
      Xmpp.send_chat(user.id, uid,"#{user.name}也来到#{shop.name}啦，回现场看看吧~", "FEED#{$uuid.generate}", " NOLOG='1' SID='#{shop.id}' SNAME='#{shop.name}' ", "<x xmlns='dface.shop' SID='#{shop.id}' SNAME='#{shop.name}' ></x>")
    end
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
