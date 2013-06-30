
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



