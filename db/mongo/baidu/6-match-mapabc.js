db.loadServerScripts();
db.tmp4.find().forEach(function(x){
	db.mapabc.update({_id:x._id},{$set:{bid:x.bid}})
})

