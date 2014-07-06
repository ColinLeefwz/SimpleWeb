db.loadServerScripts();

var i=0;
db.offsetbaidus.find().forEach(function(x){
	shop = db.baidu.findOne({lo:{$near:x.loc, $maxDistance:0.01}});
	if(shop){
		i+=1;
		sc = db.baidu_shop_around_count.findOne({_id:shop._id});
		db.heat_locs.insert({_id:i,lo:x.loc,c:sc.c});
		print(sc.c);
	}else{
		print(x.loc);
	}
})

