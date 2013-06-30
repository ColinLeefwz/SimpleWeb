
begin
  Oversea.where({country_code:  {"$exists" => true}}).each do |oversea|
    lo = oversea.lo
    key = "%.0f,%.0f" %  lo
    #puts "#{lo}, #{key}"
    $redis.set("oversea#{key}",oversea.country_code)
  end
rescue Exception => e
  puts idx
  puts e
end


begin
  Oversea.where({country_code:  {"$exists" => true}}).each do |oversea|
    lo = oversea.lo.map {|x| x.to_i}
    key = "%.0f,%.0f" %  lo
    unless $redis.get(key)
      puts "#{lo}, #{key}"
      $redis.set("oversea#{key}",oversea.country_code)
    end
  end
rescue Exception => e
  puts idx
  puts e
end


Shop.where({"$and" => [_id:{"$gt" => 20347004},_id:{"$lt" => 21000000}],city:nil}).each do |shop|
  city = Shop.get_ex_city(shop.lo)
  if city
    shop.update_attribute(:city, city)
  else
    puts shop.id
  end
end

User.where({city:nil, auto:{"$ne" => true}}).each do |user|
  ck = user.checkins.last
  next if ck.nil?
  city = ck.city
  if city.nil? && ck.shop
    city = ck.shop.city
  end
  user.update_attribute(:city, city)
end
User.where({city:{"$exists" => false}, auto:{"$ne" => true}}).each do |user|
  ck = user.checkins.last
  next if ck.nil?
  city = ck.city
  if city.nil? && ck.shop
    city = ck.shop.city
  end
  user.update_attribute(:city, city)
end

User.where({city:/^x/}).each do |u|
  ck = u.checkins.last
  x = u.gender
  x = 1 if x!=2
  key = "HOT#{x}U#{u.city}"
  puts key
  $redis.zadd(key,ck.cati, ck.uid)
end