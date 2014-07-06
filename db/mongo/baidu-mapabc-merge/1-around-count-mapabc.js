db.loadServerScripts();

function gen(offset){
db.mapabc.find().sort({_id:1}).skip(offset).forEach(function(x){
	var count = db.mapabc.count({lo:{$within:{$center:[x.lo,0.003]}}});
	db.mapabc_shop_around_count.insert({_id:x._id,c:count});
})
}

function ensure_exec(start_offset){
try{
	gen(start_offset);
}catch(e){
	offset = db.mapabc_shop_around_count.find().sort({_id:-1}).limit(1)[0]._id;
	ensure_exec(offset);
}
}

ensure_exec(db.mapabc_shop_around_count.find().sort({_id:-1}).limit(1)[0]._id);
