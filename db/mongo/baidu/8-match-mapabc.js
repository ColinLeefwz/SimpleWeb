db.loadServerScripts();

function match_name(offset){
db.mapabc.find().sort({_id:1}).skip(offset).forEach(function(x){
	db.baidu.find({name:x.name,lo:{$within:{$center:[x.lo,0.01]}}}).forEach(function(y){
		db.mapabc_baidu_ename.insert({mid:x._id,bid:y._id,name:x.name,tm:x.type,tb:y.type,dis:get_distance(x.lo,y.lo)});
	})
})
}

function ensure_exec(start_offset){
try{
	match_name(start_offset);
}catch(e){
	offset = db.mapabc_baidu_ename.find().sort({_id:-1}).limit(1)[0].mid;
	ensure_exec(offset);
}
}

ensure_exec(2309163);
