/*
{ "_id" : 10428968, "addr" : "西湖益乐路与天目山路交叉口", "city" : "0571", "name" : "古荡新村", "phone" : "", "t" : 6, "type" : "地产小区;小区<\\/font>/楼盘" }
{ "_id" : 10435591, "addr" : "西湖文三西路与益乐路交叉口", "city" : "0571",  "name" : "古荡新村西区", "phone" : "", "t" : 6, "type" : "地产小区;小区<\\/font>/楼盘" }
*/

db.loadServerScripts();

var num=0;


var old_prefix="";
var prefix_shop=null;


db.shops.find({t:6}).batchSize(10).forEach(function(x){
  num +=1;
  var e = new RegExp(x.name+".+$");
  subs = db.shops.find({lo:{$within:{$center:[x.lo,0.03]}},t:6,name:e}).toArray();
  if(subs.length>0){
	  x.subs = subs
	  db.tmp6.insert(x);
  }
  if(num%10==0) print(":"+num);
})

