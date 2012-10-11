db.loadServerScripts();
var match = function(name1,name2){
	if(name1==name2) return 1;
	if(name1.indexOf(name2)==0) return 2;
	if(name2.indexOf(name1)==0) return 3;
	return 0;
}
db.mapabc.find().sort({_id:1}).batchSize(10).skip(9940895).forEach(function(x){
	db.baidu.find({lo:{$within:{$center:[x.lo,0.005]}}}).forEach(function(y){
		var flag = match(x.name,y.name);
		if(flag>0) db.tmp5.insert({mid:x._id,bid:y._id,mname:x.name,bname:y.name,t:flag,tm:x.type,tb:y.type,dis:get_distance(x.lo,y.lo)});
	})
})

