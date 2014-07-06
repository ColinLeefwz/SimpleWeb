Shop.where({city:"0571", t:{"$exists" => true}, _id:{"$gt" => 1202842}}).sort({_id:1}).each do |shop|
 begin
  ss = Shop.similar_shops(shop,55)
  if ss.size>0
    flag = ss.find{|x| x.id<shop.id}
    next if flag
    puts "#{shop.id}\t#{shop.name}"
    ss.each {|x| puts "#{x.id}\t#{x.name}"}
    puts ""
  end
 rescue Exception => e
 end
end