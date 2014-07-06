idx = 0
begin
Shop.where({}).each do |shop|
  idx +=1
  lo = shop.loc_first
  next if lo.nil? || lo.size==0
  hash = "GCJ%.2f%.1f" %  lo
  field = ("%.2f" %  lo[1])[-1..-1]
  next if $redis.hget(hash,field)
  tmp = Mongoid.session(:dooo)[:offsets].where({loc: {'$near' => lo}}).first
  value = "%.4f,%.4f" %  tmp['d']
  $redis.hset(hash,field,value)
end
rescue Exception => e
  puts idx
  puts e.backtrace
end

#批量删除
#redis-cli -h $ipaddr0 KEYS "GCJ*" | xargs redis-cli -h $ipaddr0 DEL
