db.loadServerScripts();

function dup(offset){
	db.shops.find({_id:{$lt:20347004}}).sort({_id:1}).skip(offset).forEach(function(x){
	  dups = db.shops.find({lo : { $near : x.lo , $maxDistance : 0.02 },name:x.name, _id:{$ne : x._id}});
	  if(dups.length()>0){
		  x.sames = dups.toArray();
		  db.tmp.insert(x);
	  }
	});
}

ensure_exec(dup,"tmp");
