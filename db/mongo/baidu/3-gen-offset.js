db.loadServerScripts()
db.baidu.find().forEach(function(x){
	if(x.lo) return;
	  var loc2 = baidu_to_real(x.lob);
	print(x._id);
	  db.baidu.update({_id:x._id},{$set:{lo:loc2}});
})
