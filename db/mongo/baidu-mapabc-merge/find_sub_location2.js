/*
{ "_id" : 20332858, "addr" : "青山公路葵湧段414號", "city" : "1852", "name" : "葵星中心B座", "t" : 6, "tel" : "", "type" : "商务住宅;楼宇;商务写字楼" }
*/

db.loadServerScripts();

var num=0;

var e = new RegExp("[A-Za-z]座$");

var old_prefix="";
var prefix_shop=null;


db.shops.find({t:6,name:e}).sort({name:1}).batchSize(10).forEach(function(x){
  num +=1;
  var prefix = x.name.substring(0,x.name.length-2);
  if(prefix==old_prefix){
	dis = get_distance(x.lo,prefix_shop.lo);
	if(dis<3000){
		prefix_shop.subs.push(x);
		return;
	}
  }
  if(prefix_shop!=null){
	  if(prefix_shop.subs.length>0) db.tmp5.insert(prefix_shop);
	  prefix_shop = null;
  }
  {
	  prefix_shop = x;
	  prefix_shop.name = prefix;
	  prefix_shop.subs = [];
  }
  old_prefix = prefix;
  if(num%10==0) print(":"+num);
})

