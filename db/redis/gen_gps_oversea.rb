
begin
  Oversea.where({country_code:  {"$exists" => true}}).each do |oversea|
    lo = oversea.lo
    hash = "%.1f%.1f" %  lo
#    field = ("%.1f" %  lo[1])[-1..-1]
#    $redis.hdel(hash,field)
    $redis.set("oversea#{hash}",oversea.country_code)
  end
rescue Exception => e
  puts idx
  puts e
end

begin
  Oversea.where({country_code:  {"$exists" => true}}).each do |oversea|
    lo = oversea.lo
    hash = "%.0f,%.0f" %  lo
    #puts "#{lo}, #{hash}"
    $redis.set("oversea#{hash}",oversea.country_code)
  end
rescue Exception => e
  puts idx
  puts e
end





