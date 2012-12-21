Baidu.collection.find({type:/^(商务大厦|地产小区)/}).each do |x|
	begin
	  name = x["name"]
	  next if name =~ /门$/
	  next if name =~ /座$/
	  next if name =~ /号$/  
	  next if name =~ /院$/  
	  next if name =~ /）$/  
	  next if name =~ /\)$/  
	  next if name.length>11
	  next if Shop.where({name:name}).count>0
	  next if Shop.where({:t => 10, :name => /^#{name[0,6]}/}).count>0
	  next if Shop.where({:t => 10, :name => /^#{name[0,6]}/}).count>0
	  Shop.collection.database.session[:tmp].insert(x)
	rescue Exception =>e
		puts x.to_yaml
		puts e
	end
end

db.tmp.remove({name:/商铺$/})
db.tmp.remove({name:/号楼$/})
db.tmp.remove({name:/公司$/})
db.tmp.remove({name:/招商处$/})
db.tmp.remove({name:/筹建处$/})
db.tmp.remove({name:/销售中心$/})
db.tmp.remove({name:/售楼/})
db.tmp.remove({name:/大厦[^大]+$/})

db.tmp.find().sort({_id:1}).forEach(function(x){
	if(x.type.indexOf("商务大厦")==0) x.t=10;
	else x.t=11;
	db.shops.insert(x);
})

