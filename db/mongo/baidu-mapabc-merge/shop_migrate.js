db.loadServerScripts();

db.checkins.find({b:{$exists:false}}).forEach(function(x){
	var shop = db.shops.findOne({_id:x.sid});
	if(shop!= undefined && (shop.city=="0571" || shop.city=="010" || shop.city=="021")){
		//db.mapabc.findOne({loc:{$within:{$center:[shop.loc,0.001]}},name:shop.name})
	}else{
		var baidu = db.baidu.findOne({_id:x.sid});
		if(baidu != undefined){
			print(baidu.name);
			db.checkins.update({_id:x._id},{$set:{b:true}})
		}
		else print(x.sid);
	}
})

db.checkins.find({b:{$exists:false}}).forEach(function(x){
	db.checkins.update({_id:x._id},{$set:{oid:x.sid}})
})

db.checkins.find({b:{$exists:false}}).forEach(function(x){
	try{
		var shop = db.shops.findOne({_id:x.sid});
		if((typeof shop.lo[0]) == "number" ){
			abc = db.mapabc.findOne({lo:{$within:{$center:[shop.lo,0.001]}},name:shop.name});
		}else{
			abc = db.mapabc.findOne({lo:{$within:{$center:[shop.lo[0],0.001]}},name:shop.name});
		}
		db.checkins.update({_id:x._id},{$set:{mid:abc._id}})
	}catch(e){
		db.checkins.update({_id:x._id},{$set:{e2:true}})
	}
})

db.checkins.find({e2:{$exists:true}}).forEach(function(x){
	//mapabc中不存在的签到,比如临时的地点
	db.checkins2.insert(x);
})
db.checkins.remove({e2:{$exists:true}})


db.checkins.find({b:{$exists:false},mid:{$gt:1}}).forEach(function(x){
	var bd = db.mapabc_baidu_ename.findOne({mid:x.mid});
	if(bd!=null){
		db.checkins.update({_id:x._id},{$set:{bid:bd.bid}})
	}
})


db.checkins.find({b:{$exists:false},bid:{$gt:1}}).count();
db.checkins.find({b:{$exists:false},bid:{$gt:1}}).forEach(function(x){
	db.checkins.update({_id:x._id},{$set:{sid:x.bid}});
	db.checkins.update({_id:x._id},{$set:{b:true}});
})

db.checkins.find({b:{$exists:false}}).forEach(function(x){
	if(x.bid!=null){
		print(db.mapabc.findOne({_id:x.mid}).name);
		print(db.baidu.findOne({_id:x.bid}).name);
	}
})

db.runCommand( { distinct: 'checkins', key:'sid',query:{b:{$exists:false}} } ).values.forEach(function(x,i,arr){
	shop = db.shops.findOne({_id:x});
	ex = new RegExp("[\\(\\)]", "g");
	name2 = shop.name.replace(ex,"");
	if((typeof shop.lo[0]) == "number" ){
		loc = shop.lo;
	}else{
		loc = shop.lo[0];
	}
	bd = db.baidu.findOne({lo:{$within:{$center:[loc,0.001]}},name:new RegExp(name2, "g")});
	if(bd!=null){
		print(shop._id+"\t"+shop.name+"\t"+shop.type);
		printjson(bd);
	}
})

db.mapabc.find({type:/商务住宅;楼宇/}).skip(1).forEach(function(x){
	x.mid=x._id
	x._id = db.sp2.find().sort({_id:-1}).limit(1)[0]._id+1;
	db.sp2.insert(x);
})

db.mapabc.find({type:"商务住宅;产业园区;产业园区"}).forEach(function(x){
	x.mid=x._id
	x._id = db.sp2.find().sort({_id:-1}).limit(1)[0]._id+1;
	db.sp2.insert(x);
})