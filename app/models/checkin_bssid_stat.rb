# encoding: utf-8
class CheckinBssidStat
  include Mongoid::Document
  field :_id, type: String
  field :ssid, type: String
  #field :shops, type:Array #{id:商家id,users:[用户id,...]}, 使用该bssid签到的商家及其用户
  field :shop_id, type:Integer #实际所属商家
  field :mobile, type:Boolean #是否是可移动的WIFI
  
  #bssid 是否绑定
  def self.bind?(bssid)
    return unless (ckt =CheckinBssidStat.find_by_id(bssid))
    return ckt.shop_id
  end

  def self.insert_checkin(ck,ssid)
    CheckinBssidStat.insert(ck["bssid"],ck["sid"],ck["uid"],ssid)
  end
  
  def self.insert(bssid,sid,uid,ssid)
    return if bssid.nil? || bssid.size<10
    return if is_mobile_wifi_0(bssid,ssid)
    b = CheckinBssidStat.find_by_id(bssid)
    return if b && b.mobile
    if b.nil?
      b = CheckinBssidStat.new
      b._id = bssid
      b.ssid = ssid
      b.save
    end
    add_bssid_redis(bssid,sid)
    if b.is_mobile_wifi
      Xmpp.error_notify("发现移动wifi：#{ssid},#{bssid}, 签到商家个数#{b.shop_ids.size}")
      b.set(:mobile, true)
      $redis.del("BSSID#{bssid}")
    end
  end
  
  def is_mobile_wifi
    return true if is_mobile_wifi_0(self._id,self.ssid)
    return shop_distance_large_than(3000) #同一wifi签到的点，距离超过3000米
  end
  
  def self.is_mobile_wifi_0(bssid,ssid)
    return true if bssid[0,10]=="78:52:62:7" #贝尔tr958上网伴侣移动3G无线路由器
    return false unless ssid
    return true if ssid=="AndroidAp" || ssid=="ChinaUnicom"
    return true if ssid[0,8]=="ChinaNet"
    return true if ssid[0,4]=="CMCC"
    return true if ssid[0,10]=="MobileWiFi"
    return true if ssid =~ /PocketAP/
    return false
  end
  
  def is_mobile_wifi_0(bssid,ssid)
    CheckinBssidStat.is_mobile_wifi_0(bssid,ssid)
  end
  
  def shop_ids
    $redis.zrange("BSSID#{_id}",0,-1)
  end
  
  def shops
    shop_ids.map{|x| Shop.find_by_id(x)}.find_all{|x| x!=nil}
  end
  
  def print_shop_distance
    puts "#{ssid}, #{_id}, #{shop_id}"
    ss = shops
    ss.each_with_index do |x,i| 
      dis = x.shop_distance(ss[i-1])
      puts "#{dis}\t #{x.name},#{x.city},#{x.city_fullname}"
      puts shops[i]#["users"].each {|x| puts User.find_by_id(x).name}
    end
  end
  
  def shop_distance_large_than(distance)
    ss = shops
    return false if ss.size<2
    ss.each_with_index do |x,i| 
      return true if x.shop_distance(ss[i-1])>distance
    end
    false
  end
  
  def self.init_bssid_redis
    Checkin.where({bssid:{"$exists" => true}}).each do |ck|
      next if ck["bssid"].nil? || ck["bssid"].size<10
      next if ck.del
      next if is_kx_user?(ck.uid)
      next if ck.sid && $fake_shops.find{|id| ck.sid.to_i == id.to_i}
      add_bssid_redis(ck["bssid"],ck["sid"])
    end
  end
  
  def self.add_bssid_redis(bssid,sid,inc=1)
    score = $redis.zscore("BSSID#{bssid}",sid.to_i).to_i
    $redis.zadd("BSSID#{bssid}",score+inc, sid.to_i)
  end  
  
  def self.init_mobile_flag
    arr = []
    CheckinBssidStat.where({"mobile" => {"$ne" => true}}).each do |cbs|
      if cbs.is_mobile_wifi
        arr << cbs
        cbs.set(:mobile, true) 
      end
    end
    arr
  end

  
end

