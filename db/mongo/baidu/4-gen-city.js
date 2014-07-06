db.loadServerScripts()
db.baidu.find().forEach(function(x){
	if(x.city) return;
	print(x._id);
	var c = db.shops.findOne({lo:{$near:x.lo}}).city;
	  db.baidu.update({_id:x._id},{$set:{city:c}});
})
