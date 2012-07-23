use dface;
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

