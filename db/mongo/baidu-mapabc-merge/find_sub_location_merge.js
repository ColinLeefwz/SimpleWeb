
db.loadServerScripts();

db.tmp4.find().forEach(function(x){
	los = [x.lo];
	x.subs.forEach(function(x,i,a){los.push(x.lo)});//这里存在bug，x冲突
	if(x.name_old){
		db.shops.update({_id:x._id},{$set:{lo:los,name:x.name}});
	}else{
		db.shops.update({_id:x._id},{$set:{lo:los}});
	}
	x.subs.forEach(function(x,i,a){
		db.shops.remove({_id:x._id});
	});
})
