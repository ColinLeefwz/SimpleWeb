idx = 0
begin
Shop.where({}).limit(100).each do |shop|
  idx +=1
  lo = shop.loc_first
  hash = "OF%.2f%.1f" %  lo
  field = ("%.2f" %  lo[1])[-1..-1]
  next if $redis.hget(hash,field)
  tmp = Mongoid.session(:dooo)[:offsetbaidus].where({loc: {'$near' => lo}}).first
  value = "%.4f,%.4f" %  tmp['d']
  $redis.hset(hash,field,value)
end
rescue Exception => e
  puts idx
  puts e
end

