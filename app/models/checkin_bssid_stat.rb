class CheckinBssidStat
  include Mongoid::Document
  field :_id, type: String
  field :shops, type:Array
  
  def self.init_bssid
    Checkin.where({bssid:{"$exists" => true}}).each do |x|
      CheckinBssidStat.insert_checkin(x)
    end
  end
  
  def self.insert_checkin(ck)
    CheckinBssidStat.insert(ck["bssid"],ck["sid"],ck["uid"])
  end
  
  def self.insert(bssid,sid,uid)
    b = CheckinBssidStat.where({"_id" => bssid}).first
    if b.nil?
      CheckinBssidStat.collection.insert({"_id" => bssid, "shops" => [{id:sid,users:[uid]}] })
    else
      shops = b.shops
      shop = shops.find{|x| x["id"]==sid}
      if shop.nil?
        b.push(:shops, {id:sid,users:[uid]} )
      elsif shop["users"].size<5
        shop["users"] = shop["users"].to_set.add(uid).to_a
        b.shops = shops
        b.save!
      end
    end
  end
  
end

