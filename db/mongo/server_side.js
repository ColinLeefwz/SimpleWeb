//离线消息大小的统计

var sum_reduce = function(key, cols){
    var count=0;
    cols.forEach(function(v) {
       count+=v[key];
    });
    return {sum: count};
};

var offline_size_user = function(user){
	return sum_reduce('len',db.offlines.find({"user":user}))
}

var offline_size_all = function(){
	return sum_reduce('len',db.offlines.find())
}

db.system.js.save({ "_id" : "sum_reduce", "value" : sum_reduce })
db.system.js.save({ "_id" : "offline_size_user", "value" : offline_size_user })
db.system.js.save({ "_id" : "offline_size_all", "value" : offline_size_all })


//经纬度纠偏

var num_to_rad = function(d){
        return d * Math.PI / 180.0;
}

var get_distance4 = function( lat1,  lng1,  lat2,  lng2){
    var radLat1 = num_to_rad(lat1);
    var radLat2 = num_to_rad(lat2);
    var a = radLat1 - radLat2;
    var  b = num_to_rad(lng1) - num_to_rad(lng2);
    var s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
                                    Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
    s = s *6378.137 ;// EARTH_RADIUS;
    s = Math.round(s * 10000) / 10;
    return s;
}

var get_distance = function( loc1,loc2){

    return get_distance4(loc1[0],loc1[1],loc2[0],loc2[1]);
}



var real_to_gcj02 = function(loc){
    var tmp = db.offsets.findOne({loc: {$near : loc} });
    return [loc[0]+tmp.d[0],loc[1]+tmp.d[1]];
};

var real_to_gcj02_distance = function(loc){
    return get_distance(real_to_gcj02(loc),loc);
};


var gcj02_to_real = function(loc){
    var tmp = db.offsets.findOne({loc: {$near : loc} });
    return [loc[0]-tmp.d[0],loc[1]-tmp.d[1]];
};

var shop_distance = function(shop,loc){
	if((typeof shop.lo[0]) == "number" ) return get_distance(shop.lo,loc);
	var ret=10000;
	for(var i=0;i<shop.lo.length;i++){
		var ret0 = get_distance(shop.lo[i],loc);
		if(ret0<ret) ret=ret0;
	}
	return ret;
}

var sort_with_score = function(arr,loc,accuracy,ip,uid){
	var score = arr.map(function(x) { return [x,shop_distance(x,loc),0]; }); 
	score.forEach(function(xx,i,a) { 
		var x = xx[0]; 
		if(x.t) a[i][2]-=1; 
		if(x.del) a[i][2]+=10; 
		if(uid){
			a[i][2] -= db.checkins.count({shop_id:x._id, user_id:uid})*10;
			//区分签到和实际发言过
		}
		if(ip.indexOf(",")==-1) a[i][2] -= db.checkins.count({shop_id:x._id, ip:ip});
		a[i][2] -= db.checkins.count({shop_id:x._id, loc:{$within:{$center:[loc,0.0001]}}});
		a[i][2] -= db.checkins.count({shop_id:x._id, loc:{$within:{$center:[loc,0.0003]}}});
		printjson(xx);
		a[i][1] += (a[i][2]*accuracy/300)
	}); 
	score = score.sort(function(a,b) {return a[1]-b[1]}).slice(0,30);
	return score.map(function(x) { return x[0] }); ;
}

var find_shops = function(loc,accuracy,ip,uid){
	var radius = 0.003;
	if(accuracy<300) radius = 0.0015+0.002*accuracy/300;
    var cursor = db.shops.find({lo:{$within:{$center:[loc,radius]}}}).limit(60);
	var ret = [];
	while ( cursor.hasNext() ) ret.push(cursor.next());
    if(ret.length>=3) return sort_with_score(ret,loc,accuracy,ip,uid);
	ret = [];
	cursor = db.shops.find({lo:{$within:{$center:[loc,10*radius]}}}).limit(5);
	while ( cursor.hasNext() ) ret.push(cursor.next());
	return ret;
};


db.system.js.save({ "_id" : "num_to_rad", "value" : num_to_rad });
db.system.js.save({ "_id" : "get_distance4", "value" : get_distance4 });
db.system.js.save({ "_id" : "get_distance", "value" : get_distance });

db.system.js.save({ "_id" : "real_to_gcj02", "value" : real_to_gcj02 });
db.system.js.save({ "_id" : "real_to_gcj02_distance", "value" : real_to_gcj02_distance });

db.system.js.save({ "_id" : "gcj02_to_real", "value" : gcj02_to_real });

db.system.js.save({ "_id" : "shop_distance", "value" : shop_distance });
db.system.js.save({ "_id" : "sort_with_score", "value" : sort_with_score });
db.system.js.save({ "_id" : "find_shops", "value" : find_shops });



var shop_user_count = function(sid){
    var users={};
    var all=0,female=0;
    db.checkins.find({shop_id:sid}).forEach(function(x){
        //TODO: 只统计最近一个月的访问用户
        if(!users[x.user_id]){ //不重复统计同一个用户
            all+=1;
            if(x.gender==2) female+=1;
            users[x.user_id] = x._id;
        }
    });
    return [all,all-female,female];
}
db.system.js.save({ "_id" : "shop_user_count", "value" : shop_user_count });


var shop_users = function(sid){
    var users={};
    var count=0;
    db.checkins.find({shop_id:sid}).sort({_id:-1}).limit(1000).forEach(function(x){
        //TODO: 只统计最近一个月的访问用户
        if(count>=100) return;
        if(!users[x.user_id]){ //不重复统计同一个用户
            users[x.user_id] = x._id.getTimestamp();
            count+=1;
        }
    });
    return users;
}
db.system.js.save({ "_id" : "shop_users", "value" : shop_users });
