/*
{ "_id" : ObjectId("500fdd85421aa945f4a6b33c"), "loc" : [ 30.27785, 120.111881 ], "name" : "嘉绿苑西区(东一门)", "type" : "商务住宅;住宅区;住宅小区" }
{ "_id" : ObjectId("500fdd85421aa945f4a6b76b"), "loc" : [ 30.278031, 120.111866 ], "name" : "嘉绿苑西区(东二门)", "type" : "商务住宅;住宅区;住宅小区" }
*/

var num=0;

var e = new RegExp("\\([^\\)]*\\)$");

var old_prefix="";
var old_x=null;

function diff(x,y){
	if(y==null) return 100;
	dx = (x.loc[0]-y.loc[0])*1;
	dy = (x.loc[1]-y.loc[1])*1;
	return Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2));
}

function distance(x){
	if(x.type.indexOf("交通设施服务")==0) return 0.03;
	if(x.type.indexOf("购物服务;商场;购物中心")==0) return 0.03;
	if(x.type.indexOf("风景名胜")==0) return 0.03;
	if(x.type.indexOf("商务住宅")==0) return 0.03;
	return 0.01;
}

db.mapabc2.find({name:e}).sort({name:1}).forEach(function(x){
  num +=1;
  var prefix = x.name.substring(0,x.name.lastIndexOf("("));
  if(prefix.length==0){
	old_prefix="";
	old_x=null;
	return;
  }
  if(prefix==old_prefix){
	if(diff(x,old_x)<distance(x)){
		db.tmp3.insert(old_x);
		db.tmp3.insert(x);	
	}
  }
  old_prefix = prefix;
  old_x = x;
  if(num%1000==0) print(":"+num);
})


db.tmp3.find().forEach(function(x){
	db.mapabc2.remove(x)
})



var old_prefix="";
var old_x=null;
var loc_arr=[];

db.tmp3.find().sort({name:1}).forEach(function(x){
  var prefix = x.name.substring(0,x.name.lastIndexOf("("));
  if(prefix==old_prefix && diff(x,old_x)<distance(x) ){
	loc_arr.push(x.loc);
  }else{
	if(old_x!=null){
		old_x.loc = loc_arr;
		old_x.name = prefix;
		db.tmp4.insert(old_x);
	}
	old_prefix = prefix;
	old_x = x;
	loc_arr=[x.loc];
  }
})

