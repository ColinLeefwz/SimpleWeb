db.loadServerScripts();
var match = function(name1,name2){
	if(name1==name2) return 1;
	if(name1.indexOf(name2)!=-1) return 2;
	if(name2.indexOf(name1)!=-1) return 3;
	return 0;
}
db.mapabc.find().forEach(function(x){
	db.baidu.find({lo:{$within:{$center:[x.lo,0.0016]}}}).forEach(function(y){
		var flag = match(x.name,y.name);
		if(flag>0) db.tmp4.insert({_id:x._id,bid:y._id,t:flag,tm:x.type,tb:y.type,dis:get_distance(x.lo,y.lo)});
	})
})

