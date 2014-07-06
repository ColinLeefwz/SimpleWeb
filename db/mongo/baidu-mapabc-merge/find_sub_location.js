/*
{ "_id" : ObjectId("500fdd85421aa945f4a6b33c"), "loc" : [ 30.27785, 120.111881 ], "name" : "嘉绿苑西区(东一门)", "type" : "商务住宅;住宅区;住宅小区" }
{ "_id" : ObjectId("500fdd85421aa945f4a6b76b"), "loc" : [ 30.278031, 120.111866 ], "name" : "嘉绿苑西区(东二门)", "type" : "商务住宅;住宅区;住宅小区" }
*/

db.loadServerScripts();

var num=0;

var e = new RegExp("\\([^\\)]*\\)$");

var old_prefix="";
var prefix_shop=null;


db.shops.find({t:6,name:e}).sort({name:1}).batchSize(10).forEach(function(x){
  num +=1;
  var prefix = x.name.substring(0,x.name.lastIndexOf("("));
  if(prefix.length==0){
	old_prefix="";
	return;
  }
  if(prefix==old_prefix){
	dis = get_distance(x.lo,prefix_shop.lo);
	if(dis<3000){
		prefix_shop.subs.push(x);
		return;
	}
  }
  if(prefix_shop!=null){
	  if(prefix_shop.subs.length>0) db.tmp4.insert(prefix_shop);
	  prefix_shop = null;
  }
  prefix_shop = db.shops.findOne({name:prefix,lo:{$within:{$center:[x.lo,0.02]}}});
  if(prefix_shop!=null){
	  prefix_shop.subs = [x];
  }else{
	  prefix_shop = x;
	  prefix_shop.name_old = x.name;
	  prefix_shop.name = prefix;
	  prefix_shop.subs = [];
  }
  old_prefix = prefix;
  if(num%10==0) print(":"+num);
})

