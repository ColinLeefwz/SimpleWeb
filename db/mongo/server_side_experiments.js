
var shop_users = function(sid){
    var users={};
    var count=0;
    db.checkins.find({sid:sid}).sort({_id:-1}).limit(1000).forEach(function(x){
        //TODO: 只统计最近一个月的访问用户
        if(count>=100) return;
        if(!users[x.uid]){ //不重复统计同一个用户
            users[x.uid] = x._id;
            count+=1;
        }
    });

    return users;
}
db.system.js.save({ "_id" : "shop_users", "value" : shop_users });

//////////////////////////////////////////////////////////////////////////////////////

var _map = function () {
    emit(this.user_id, {doc:this});
}

var _reduce = function (key, values) {
    var ret = {doc:[]};
    var doc = {};
    values.forEach(function (value) {
    if (!doc[value.doc.user_id]) {
           ret.doc.push(value.doc);
           doc[value.doc.user_id] = true; //make the doc seen, so it will be picked only once
       }
    });
    return ret;
}

var shop_users = function(sid){
    return db.checkins.mapReduce(_map,_reduce,{
        query:{sid:sid},
        sort:{_id:-1},
        out: { inline : 1},
    })
}

/////////////////////////////////////////////////////////////


var distinct_map_reduce = function(key){
    var distinct_map = function () {
        emit(this[key], {doc:this});
    }

    var distinct_reduce = function (mkey, values) {
        var ret = {doc:[]};
        var doc = {};
        values.forEach(function (value) {
        if (!doc[value.doc[key]]) {
               ret.doc.push(value.doc);
               doc[value.doc[key]] = true; //make the doc seen, so it will be picked only once
           }
        });
        return ret;
    }
    return [distinct_map,distinct_reduce]
}

var shop_users = function(sid){
    mr = distinct_map_reduce("user_id")
    print(mr[0])
    return db.checkins.mapReduce(mr[0],mr[1],{ //mapreduce执行时，拿不到闭包变量key?
        query:{sid:sid},
        sort:{_id:-1},
        out: { inline : 1},
    })
}

