db.loadServerScripts();

function match_name(offset){
db.mapabc.find().sort({_id:1}).skip(offset).forEach(function(x){
	if(x.name.charAt(x.name.length-1)==')'){
		name2 = x.name.substring(0, x.name.length-1);
		name2 = name2.split("(").join("");
		db.baidu.find({name:name2,lo:{$within:{$center:[x.lo,0.002]}}}).forEach(function(y){
			db.mapabc_baidu_ename2.insert({mid:x._id,bid:y._id,name:x.name,tm:x.type,tb:y.type,dis:get_distance(x.lo,y.lo)});
		})	
	}
})
}

function ensure_exec(start_offset){
try{
	match_name(start_offset);
}catch(e){
	offset = db.mapabc_baidu_ename2.find().sort({_id:-1}).limit(1)[0].mid;
	ensure_exec(offset);
}
}

ensure_exec(0);
