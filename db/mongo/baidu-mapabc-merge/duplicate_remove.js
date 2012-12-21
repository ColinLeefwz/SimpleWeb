db.loadServerScripts();

function dup(offset){
	db.shops.find({t: { $in : [ 10,11 ] }}).sort({_id:1}).skip(offset).forEach(function(x){
	  dups = db.shops.find({_id:{$gt:x._id}, t: { $in: [ 10,11 ] }, lo : { $near : x.lo , $maxDistance : 0.02 },name:x.name, _id:{$ne : x._id}});
	  if(dups.length()>0){
		  x.sames = dups.toArray();
		  db.tmp.insert(x);
	  }
	  if(x._id%10000==0) print(x._id);
	});
}

ensure_exec(dup,"tmp",0);
