var num=0;
var for2 = function (cursor, func) {
    while (cursor.hasNext()) {
        if(!func(cursor.next())) return;
    }
}

db.mapabc2.find().sort({name:1}).forEach(function(x){
  num +=1;
  var flag=false;
  var start_with = function(xx){
	    //print(xx.name+" : "+x.name);
    if(xx.name.indexOf(x.name+"(")==0){
        print(xx._id);
        flag=true;
        return true;
    }else{
        return false;
    }
  }

  for2(db.mapabc2.find({name:{$gt: x.name+"("}, loc : { $near : x.loc , $maxDistance : 0.1 }}).sort({name:1}).limit(20),start_with);

  if(flag){
    print(x._id);
    print(".");
  }    
  if(num%1000==0) print(":"+num);
})
