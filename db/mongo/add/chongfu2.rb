
Shop.where({t:{"$exists" => true}}).sort({_id:1}).each do |x|
  begin
    sames =[]
	  Shop.where({lo:{"$within" => {"$center" => [x["lo"],0.01]}}, t:x["t"]}).each do |y|
      score = Shop.similarity(x,y)
      sames << [y,score] if score>60
    end
    if sames.size>0
      x["sames"] = sames
      Shop.collection.database.session[:chongfu2].insert(x)
    end
  rescue Exception =>e
    puts x.to_yaml
    puts e
  end
end
