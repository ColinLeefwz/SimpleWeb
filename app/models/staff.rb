class Staff
  include Mongoid::Document
  field :user_id
  field :shop_id

  def self.find_by_id(id)
    begin
      Staff.find(id)
    rescue
      nil
    end
  end
  
  def user
    User.find2(user_id)
  end

  def shop
    Shop.find_by_id(shop_id)
  end

  def checkin_count(uid)
    Checkin.where({sid: shop_id, uid: uid}).count
  end

end
