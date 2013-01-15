last = Shop.collection.database.session[:chongfu3].find().sort({_id:-1}).one
if last.nil?
 fid = 0
else
 fid = last["_id"]
end


Shop.collection.find({t:{"$gt" => 4}, "_id" => {"$gt" => fid}  }).sort({_id:1}).each do |x|
  begin
    sames =[]
	  Shop.where({lo:{"$within" => {"$center" => [x["lo"],0.01]}}, t:x["t"]}).each do |y|
	next if x["_id"]==y["_id"]
      score = Shop.similarity(x,y)
      sames << [y["_id"],score] if score>60
    end
    if sames.size>0
      x["sames"] = sames
      Shop.collection.database.session[:chongfu3].insert(x)
    end
  rescue Exception =>e
    puts x.to_yaml
    puts e
  end
end
