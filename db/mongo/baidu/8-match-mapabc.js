db.loadServerScripts();
db.mapabc.find().sort({_id:1}).forEach(function(x){
	db.baidu.find({name:x.name,lo:{$within:{$center:[x.lo,0.01]}}}).forEach(function(y){
		db.mapabc_baidu_ename.insert({mid:x._id,bid:y._id,name:x.name,t:flag,tm:x.type,tb:y.type,dis:get_distance(x.lo,y.lo)});
	})
})

