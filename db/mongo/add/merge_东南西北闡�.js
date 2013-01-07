
db.shops.find({t:{$in: [10,11]}, name:/[东南西北]门$/}).forEach(function(x){
	db.tmp_gate.insert(x);
})


db.tmp_gate.find().forEach(function(x){
	name=x.name.substr(0,x.name.length-2);
	lo = x.lo
	if((typeof x.lo[0]) != "number") lo=x.lo[0];
	shop = db.shops.findOne({name:name, lo:{$within:{$center:[lo,0.002]}}});
	if(shop){
		x.shop = shop;
		db.tmp_gate3.insert(x);
	}
})

db.tmp_gate.find().forEach(function(x){
	name=x.name.substr(0,x.name.length-3);
	lo = x.lo
	if((typeof x.lo[0]) != "number") lo=x.lo[0];
	shop = db.shops.findOne({name:name, lo:{$within:{$center:[lo,0.002]}}});
	if(shop){
		x.shop = shop;
		db.tmp_gate3.insert(x);
	}
})


db.tmp_gate3.find().forEach(function(x){
	db.tmp_gate.remove({_id:x._id});
})

db.tmp_gate3.find().forEach(function(x){
	lo = x.shop.lo;
	if((typeof lo[0]) == "number") lo=[lo];
	lo.push(x.lo);
	db.shops.update({_id:x.shop._id},{$set:{lo:lo}});
})

db.tmp_gate3.find().forEach(function(x){
	db.shops.remove({_id:x._id});
})

db.tmp_gate3.drop();

pname="";
merge=[];
db.tmp_gate.find().sort({name:1}).forEach(function(x){
	name=x.name.substr(0,x.name.length-2);
	if(name.match(/[东南西北]$/)) name=x.name.substr(0,x.name.length-3);
	print(name+"\t"+x.name);
	if(pname==name){
		merge.push(x);
	}else{
		if(merge.length>1){
			shop={};
			shop.name = pname;
			shop.arr = merge;
			db.tmp_gate4.insert(shop);
		}
		pname=name;
		merge=[x];
	}
})


db.tmp_gate4.find().forEach(function(x){
	shop = x.arr[0];
	shop.name = x.name;
	lo = [];
	for(var i=0;i<x.arr.length;i++) lo.push(x.arr[i].lo);
	shop.lo = lo;
  db.tmp_gate5.insert(shop);
})

db.tmp_gate4.find().forEach(function(x){
	for(var i=0;i<x.arr.length;i++){
		id = x.arr[i]._id;
		db.shops.remove({_id:id});
	}
})

db.tmp_gate4.find().forEach(function(x){
	for(var i=0;i<x.arr.length;i++){
		id = x.arr[i]._id;
		db.tmp_gate.remove({_id:id});
	}
})

//db.tmp_gate4.drop();

db.tmp_gate5.find().forEach(function(x){
	db.shops.insert(x);
})

db.tmp_gate.find().forEach(function(x){
  name=x.name.substr(0,x.name.length-2);
	if(name.match(/[东南西北]$/)) name=x.name.substr(0,x.name.length-3);
	db.shops.update({_id:x._id},{$set:{name:name}});
})



