#海外用户的城市

User.where({city: {"$exists" => false}}).each do |user|
  next unless (checkin = Checkin.where({uid: user.id}).sort({_id:  1}).limit(1).first)
  next unless (shop = checkin.shop)
  lo = shop.loc_first
  hash = "%.1f%.1f" %  lo
  next unless (code = $redis.get("over#{hash}"))
  # put code
  user.update_attribute(:city, code)
end

#海外商家的city
Shop.where({city: {"$exists" => false}}).each do |shop|
  begin
    lo = shop.loc_first
    hash = "%.1f%.1f" %  lo
    next unless (code = $redis.get("over#{hash}"))
    shop.update_attribute(:city, code)
    # puts code
  rescue
    next
  end
end