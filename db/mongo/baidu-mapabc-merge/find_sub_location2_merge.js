db.tmp5.find().forEach(function(x){
	los = [x.lo];
	x.subs.forEach(function(x,i,a){los.push(x.lo)});
	db.shops.update({_id:x._id},{$set:{lo:los,name:x.name}});
	x.subs.forEach(function(x,i,a){
		db.shops.remove({_id:x._id});
	});
})