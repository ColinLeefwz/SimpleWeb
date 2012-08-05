 
db.shops.find().forEach(function(x){
  if((typeof x.loc[0]) == "number"){
	  if( (typeof x.lo) == "object") return;
	  var str = "gcj02_to_real(["+x.loc+"])";
	  var loc2 = db.eval(str);
	  db.shops.update({_id:x._id},{$set:{lo:loc2}});
  }else{
	var arr = new Array( );
	for(var i=0;i<x.loc.length;i++){
	  var str = "gcj02_to_real(["+x.loc[i]+"])";
	  arr.push( db.eval(str) );	
	}
	db.shops.update({_id:x._id},{$set:{lo:arr}});
  }
  
})
