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
    var tmp = db.offsets.findOne({
        loc: {
            $near : loc
        }
    });
    return [loc[0]+tmp.d[0],loc[1]+tmp.d[1]];
};

var real_to_gcj02_distance = function(loc){
    return get_distance(real_to_gcj02(loc),loc);
};


var gcj02_to_real = function(loc){
    var tmp = db.offsets.findOne({
        loc: {
            $near : loc
        }
    });
    return [loc[0]-tmp.d[0],loc[1]-tmp.d[1]];
};

var baidu_to_real = function(loc){
    var tmp = db.offsetbaidus.findOne({
        loc: {
            $near : loc
        }
    });
    return [loc[0]-tmp.d[0],loc[1]-tmp.d[1]];
};

var real_to_baidu = function(loc){
    var tmp = db.offsetbaidus.findOne({
        loc: {
            $near : loc
        }
    });
    return [loc[0]+tmp.d[0],loc[1]+tmp.d[1]];
};


db.system.js.save({
    "_id" : "num_to_rad",
    "value" : num_to_rad
});
db.system.js.save({
    "_id" : "get_distance4",
    "value" : get_distance4
});
db.system.js.save({
    "_id" : "get_distance",
    "value" : get_distance
});

db.system.js.save({
    "_id" : "real_to_gcj02",
    "value" : real_to_gcj02
});
db.system.js.save({
    "_id" : "real_to_gcj02_distance",
    "value" : real_to_gcj02_distance
});

db.system.js.save({
    "_id" : "gcj02_to_real",
    "value" : gcj02_to_real
});

db.system.js.save({
    "_id" : "baidu_to_real",
    "value" : baidu_to_real
});


var shop_distance = function(shop,loc){
    if((typeof shop.lo[0]) == "number" ) return get_distance(shop.lo,loc);
    var ret=10000;
    for(var i=0;i<shop.lo.length;i++){
        var ret0 = get_distance(shop.lo[i],loc);
        if(ret0<ret) ret=ret0;
    }
    return ret;
}

var do_score = function(x,i,a){
    var today = new Date();
    var hour = today.getHours();
    var hminute = hour*60+today.getMinutes();
    var stype = x.type;
    if(!stype) stype='';
    if(x.t) a[i][2]-=5;
    if(x.del) a[i][2]+=30;
    if(x.t==4 && stype.indexOf('风景名胜')==0) a[i][2]+=20;
    if(x.t==3 && stype.indexOf('餐饮服务')==0){
        if(hour>=11 && hour<=13) a[i][2]-=20;
        else if(hour>=17 && hour<=19) a[i][2]-=20;
        else if(hminute>(14*60+30) && hminute<(16*60+30) ) a[i][2] +=30;
    };
    if(x.t==1){
        if(hour>=20 || hour <=3) a[i][2]-=30;
    };
    if(x.t==6){
        if(stype.indexOf('商务住宅')==0){
            if(stype.indexOf('商务住宅;住宅区')==0){
                if(hour>=20 || hour<=8) a[i][2] -=10;
            }else{
                var week = today.getDay();
                if(week>=1 && week<=5){
                    if(hour>=14 && hour<=17) a[i][2] -=10;
                    if(hour>=8 && hour<=11) a[i][2] -=10;
                    if(hour>=19) a[i][2] +=20;
                }else{
                    a[i][2] +=20;
                }
            }
        }
    };
    if((typeof x.lo[0]) != "number" )  a[i][2]-=5; 
}

var sort_with_score = function(arr,loc,accuracy,ip,uid){
    var score = arr.map(function(x) {
        return [x,shop_distance(x,loc),0];
    });
    score.forEach(function(xx,i,a) {
        var x = xx[0];
        do_score(x,i,a);
        var sc = db.checkin_shop_stats.findOne({
            "_id":x._id
        });
        if(sc){
            if(uid && sc.users[uid]){
                ucount = sc.users[uid][0];
                a[i][2] -= ucount*30;
            };
            if(ip.indexOf(",")==-1){
                var ip2 = ip.replace('.', '/', 'g');
                var ip2s = sc.ips[ip2];
                if(ip2s){
                    ipcount = sc.ips[ip2][0];
                    a[i][2] -= ipcount*5;
                }
            } 
        }
        if(a[i][2]<-200) a[i][2]=-200; //最多加权2/3后封顶
        //printjson(xx);
        a[i][1] += (a[i][2]*accuracy/300);
    });
    score = score.sort(function(a,b) {
        return a[1]-b[1]
    }).slice(0,30);
    return score;
}

var find_shops = function(loc,accuracy,ip,uid){
    var radius = 0.003; //约300米
    radius = 0.0015+0.002*accuracy/300;
    if(radius>1000) radius=1000; 
    var cursor = db.shops.find({
        lo:{
            $within:{
                $center:[loc,radius]
            }
        }
    }).limit(100);
    var ret = [];
    while ( cursor.hasNext() ) ret.push(cursor.next());
    if(ret.length>=3) return sort_with_score(ret,loc,accuracy,ip,uid);
    cursor = db.shops.find( { lo : { $near : loc } } ).limit(5);
    while ( ret.length<5 && cursor.hasNext() ){
        var tmpshop = cursor.next();
        var existflag = false;
        for(var i=0;i<ret.length;i++){
            if(ret[i]._id == tmpshop._id){
                existflag = true;
                break;
            }
        }
        if(!existflag) ret.push(tmpshop);
    }
    return ret;
};

db.system.js.save({
    "_id" : "shop_distance",
    "value" : shop_distance
});
db.system.js.save({
    "_id" : "do_score",
    "value" : do_score
});
db.system.js.save({
    "_id" : "sort_with_score",
    "value" : sort_with_score
});
db.system.js.save({
    "_id" : "find_shops",
    "value" : find_shops
});


//查找附近的商家，先按商家用户数utotal排序，如果商家数量不足pcount个，那么按距离再查询出剩余商家。
var nearby_shops = function(loc,page,pcount,t,name){
    var skip = (page-1)*pcount;
    var city = db.shops.findOne({
        lo:{
            $near:loc
        }
    }).city;
    var search_hash = {
        utotal:{
            $gt:0
        },
        city:city
    };
    if(t>0) search_hash["t"]=t;
    if(name)  search_hash["name"]= name ;
    var cursor = db.shops.find(search_hash).sort({
        utotal:-1
    }).skip(skip).limit(pcount);
    var ret = [];
    while ( cursor.hasNext() ) ret.push(cursor.next());
    ret.sort(function(a,b){
        if(a.utotal!=b.utotal) return b.utotal-a.utotal; // 按utotal降序
        else return shop_distance(a,loc) - shop_distance(b,loc); //按距离升序
    });
    var diff = pcount-ret.length;
    if(diff==0) return ret;
    var count = db.shops.count(search_hash);
    if(diff<pcount) skip2 = 0;
    else skip2 = skip-count;
    var hash2 = {
        lo:{
            $within:{
                $center:[loc,0.1]
            }
        }
    };
    if(t>0) hash2["t"]=t;
    if(name)  hash2["name"]=name;
    var cursor2 = db.shops.find(hash2).skip(skip2).limit(diff);
    while ( cursor2.hasNext() ) ret.push(cursor2.next());
    return ret;
}

db.system.js.save({
    "_id" : "nearby_shops",
    "value" : nearby_shops
});


//用于商家签到的周排行和月排行统计。总排行直接查询checkin_shop_stats即可。
var groupCheckin = function(sid, objectid){

    var gr = db.checkins.group({
        "key" : {
            uid: true
        },
        initial:{
            count: 0
        },
        "$reduce" : function(doc, prev) {
            prev.count += 1
        },
        "cond" : {
            _id: {
                "$gt": ObjectId(objectid)
            },
            sid: sid,
            del: {
                $exists: false
            }
        }
    });
    return gr;
}


db.system.js.save({
    "_id" : "groupCheckin",
    "value" : groupCheckin
})






