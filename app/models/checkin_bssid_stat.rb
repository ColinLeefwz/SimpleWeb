# encoding: utf-8
class CheckinBssidStat
  include Mongoid::Document
  field :_id, type: String
  field :ssid, type: String
  field :shops, type:Array #{id:商家id,users:[用户id,...]}, 使用该bssid签到的商家及其用户
  field :shop_id, type:Integer #实际所属商家
  
  $kxs = ["502e6303421aa918ba000001","5032e88d421aa91a1e000016","50446058421aa92042000002","50bc20fcc90d8ba33600004b","502e6303421aa918ba000079"].to_set
  
  def self.kx_users(arr)
    arr.map{|x| x.to_s}.to_set & $kxs
  end
  
  def self.init_shop_id
    puts CheckinBssidStat.where({shop_id:nil}).count
    sum=0
    CheckinBssidStat.where({shop_id:nil}).each do |x|
      flag = x.try_set_shop_id
      sum+=1 if flag
    end
    puts sum
  end
  
  def try_set_shop_id
    arr = shops.map {|hash| [hash["id"] ,CheckinBssidStat.kx_users(hash["users"]).size, hash["users"].size] }
    arr2 = arr.find_all{|a| a[1]>0 || a[2]>1} #可信用户签到，或者有两人以上签到
    return false unless arr2.length>0
    puts self._id
    arr2.each {|a| a[3]=CheckinShopStat.find_by_id(a[0])}
    arr2 = arr2.find_all {|a| a[3]!=nil}
    arr2.each {|a| a[3]=a[3].ctotal}
    arr2.each {|a| a[4]=a[1]*20+a[2]*10+a[3]} #积分
    arr2 = arr2.find_all {|a| a[4]>25}
    if arr2.size==0   
      puts "没有商家达到25分的最低标准" 
      return false
    end
    if arr2.size==1
      puts "唯一商家: #{Shop.find(arr2[0][0]).name}"
      self.update_attribute(:shop_id, arr2[0][0])
      return true
    end
    arr2.sort! {|a,b| b[4]<=>a[4]}
    if arr2[0][4]>arr2[1][4]+2
      puts arr2
      puts "积分最大商家: #{Shop.find(arr2[0][0]).name}"
      self.update_attribute(:shop_id, arr2[0][0])
      return true
    else
      puts "积分基本相等商家: #{Shop.find(arr2[0][0]).name}，#{Shop.find(arr2[1][0]).name}"
      return false
    end
  end
  
  def self.init_bssid
    Checkin.where({bssid:{"$exists" => true}}).each do |x|
      CheckinBssidStat.insert_checkin(x)
    end
  end
  
  def self.insert_checkin(ck,ssid)
    CheckinBssidStat.insert(ck["bssid"],ck["sid"],ck["uid"],ssid)
  end
  
  def self.insert(bssid,sid,uid,ssid)
    b = CheckinBssidStat.where({"_id" => bssid}).first
    if b.nil?
      CheckinBssidStat.collection.insert({"_id" => bssid, "ssid" => ssid, "shops" => [{id:sid,users:[uid]}] })
    else
      b.update_attribute(:ssid, ssid) if b.ssid.nil? && ssid
      return if b.shop_id
      shops = b.shops
      shop = shops.find{|x| x["id"]==sid}
      if shop.nil?
        b.push(:shops, {id:sid,users:[uid]} )
      elsif shop["users"].size<5
        shop["users"] = shop["users"].to_set.add(uid).to_a
        b.shops = shops
        b.save!
        b.try_set_shop_id if shop["users"].size>1
      end
    end
  end
  
end

