idx = 0

begin
  Oversea.where({country_code:  {"$exists" => true}}).each do |oversea|
    idx +=1
    lo = oversea.lo
    hash = "%.1f%.1f" %  lo
    field = ("%.1f" %  lo[1])[-1..-1]
    $redis.hset(hash,field,oversea.country_code) if oversea.country_code
  end
rescue Exception => e
  puts idx
  puts e
end