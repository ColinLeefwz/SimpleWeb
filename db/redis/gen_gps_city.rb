idx = 0
begin
Shop.where({city:{"$exists" => true}}).skip(1000000).each do |shop|
  idx +=1
  lo = shop.loc_first
  hash = "%.2f%.1f" %  lo
  field = ("%.2f" %  lo[1])[-1..-1]
  $redis.hset(hash,field,shop.city) if shop.city
end
rescue Exception => e
  puts idx
  puts e
end

