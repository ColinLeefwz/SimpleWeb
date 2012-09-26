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
		print("#"+xx.name+"\t"+xx.type);
        flag=true;
        return true;
    }else{
        return false;
    }
  }

  for2(db.mapabc2.find({name:{$gt: x.name+"("}, loc : { $near : x.loc , $maxDistance : 0.03 }}).sort({name:1}),start_with);

//maxDistance就是三角公式计算，没有物理含义。实际距离估算0.03约为3000米
//mongodb中sort然后limit的效果似乎是先limit后sort,所以只能取消limit

  if(flag){
    print(x._id);
	print("#"+x.name+"\t"+x.type);
    print(".");
  }    
  if(num%1000==0) print(":"+num);
})



