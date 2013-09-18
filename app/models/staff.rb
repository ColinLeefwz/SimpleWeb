class Staff
  include Mongoid::Document
  field :user_id
  field :shop_id
  
  index({ shop_id: 1})
  
  def user
    User.find_by_id(user_id)
  end

  def shop
    Shop.find_by_id(shop_id)
  end

  def checkin_count(uid)
    Checkin.where({sid: shop_id, uid: uid}).count
  end
  
  def self.is_staff(uid,sid)
    $redis.sismember("STAFF#{uid}", sid)
  end
  
  def self.shops(uid)
    $redis.smembers("STAFF#{uid}")
  end

end
