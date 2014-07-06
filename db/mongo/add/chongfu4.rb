last = Shop.collection.database.session[:chongfu4].find().sort({_id:-1}).one
if last.nil?
 fid = 0
else
 fid = last["_id"]
end

shop = Shop.new
Shop.collection.find({t:{"$gt" => 4}, "_id" => {"$gt" => fid}  }).sort({_id:1}).each do |x|
  begin
    next if Shop.collection.database.session[:chongfu4].find({"sames.id" => x["_id"] }).one
    sames =[]
    Shop.where({lo:{"$within" => {"$center" => [shop.loc_first_of(x),0.003]}}, t:x["t"], "_id" => {"$gt" => x["_id"]}} ).each do |y|
      next if x["_id"]==y["_id"]
      score = Shop.similarity(x,y)
      sames << {"id" => y["_id"], "score" => score}  if score>60
    end
    if sames.size>0
      x["sames"] = sames
      Shop.collection.database.session[:chongfu4].insert(x)
    end
  rescue Exception =>e
    puts x.to_yaml
    puts e
    puts e.backtrace.join("\n")
  end
end
