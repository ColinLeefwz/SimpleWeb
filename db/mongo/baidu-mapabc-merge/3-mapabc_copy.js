db.loadServerScripts();

var cur = db.sp2.find().sort({_id:-1}).limit(1)[0]._id;

db.mapabc.find({type:/商务住宅;楼宇/}).forEach(function(x){
	x.mid=x._id
	x._id = cur+1;
	cur += 1;
	db.sp2.insert(x);
})

db.mapabc.find({type:"商务住宅;产业园区;产业园区"}).forEach(function(x){
	x.mid=x._id
	x._id = cur+1;
	cur += 1;
	db.sp2.insert(x);
})