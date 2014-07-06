Baidu.collection.find({type:/^餐饮/}).each do |x|
	begin
	  name = x["name"]
	  next if name =~ /公司/
	  next if name == "麻辣烫"
	  next if name.length>15
	  next if Shop.where({_id:x["_id"]}).count>0
          next if Shop.where({city:x["city"], name:x["name"]}).count>0
	  Shop.collection.database.session[:tmp].insert(x)
	rescue Exception =>e
		puts x.to_yaml
		puts e
	end
end

