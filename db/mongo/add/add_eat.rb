Baidu.collection.find({type:/^餐饮/}).each do |x|
	begin
	  name = x["name"]
	  next if name =~ /公司/
	  next if name == "麻辣烫"
	  next if name.length>12
	  next if Shop.where({_id:x["_id"]}).count>0
	  Shop.collection.database.session[:tmp2].insert(x)
	rescue Exception =>e
		puts x.to_yaml
		puts e
	end
end

