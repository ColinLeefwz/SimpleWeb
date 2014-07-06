
db.tmp6.find().forEach(function(x){
	los = [x.lo];
	x.subs.forEach(function(x,i,a){los.push(x.lo)}); //bug
	db.tmp6.update({_id:x._id},{$set:{lo:los}});
})

db.tmp6.find().forEach(function(x){
	if((typeof x.lo[0]) != "number"){
		if((typeof x.lo[0][0]) != "number"){
			var loc = x.lo[0]
			db.tmp6.update({_id:x._id},{$set:{lo:loc}});
		}
	}
})

db.shops.find({del2:true}).forEach(function(x){
	if((typeof x.lo[0]) == "number"){
		db.shops.remove({_id:x._id})
	}
})

db.shops.find({del2:true}).forEach(function(x){
	if(x.name.match(/[0-9]+/)) {
		db.shops.remove({_id:x._id})
	}
})
db.shops.find({del2:true}).forEach(function(x){
	if(x.name.match(/[a-zA-Z]+/)) {
		db.shops.remove({_id:x._id})
	}
})
