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

var get_distance4 = function( lat1,  lng1,  lat2,  lng2){
    function rad(d){
        return d * Math.PI / 180.0;
    }
    var radLat1 = rad(lat1);
    var radLat2 = rad(lat2);
    var a = radLat1 - radLat2;
    var  b = rad(lng1) - rad(lng2);
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

db.system.js.save({ "_id" : "get_distance", "value" : get_distance });
db.system.js.save({ "_id" : "real_to_gcj02", "value" : real_to_gcj02 });
db.system.js.save({ "_id" : "real_to_gcj02_distance", "value" : real_to_gcj02_distance });
