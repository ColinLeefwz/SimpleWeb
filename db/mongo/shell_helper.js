
var last = function(col_name){
    return eval("db."+col_name+".find().sort({_id:-1}).limit(1)");
}

var first = function(col_name){
    return eval("db."+col_name+".find().sort({_id:1}).limit(1)");
}


db.system.js.save({
    "_id" : "last",
    "value" : last
})
db.system.js.save({
    "_id" : "first",
    "value" : first
})

var shop_hz = function(name){
	var reg = new RegExp(name);
    return db.shops.find({city:"0571",name:reg});
}

db.system.js.save({
    "_id" : "shop_hz",
    "value" : shop_hz
})

function ensure_exec(fun,dest_coll,start_offset){
try{
	if(start_offset==undefined) throw "no start_offset";
	fun(start_offset);
}catch(e){
	print(e);
	offset = eval("db."+dest_coll+".find().sort({_id:-1}).limit(1)[0]._id");
	ensure_exec(fun,dest_coll,offset);
}
}

db.system.js.save({
    "_id" : "ensure_exec",
    "value" : ensure_exec
})


var gen_day_id =function(days){
    var day =  new Date(parseInt(((new Date()).valueOf()/1000)-(days*24*60*60))*1000);
    var id = day.toLocaleFormat('%Y-%m-%d');
    var z = '0000000000000000';
    var idOfBeginDAy = parseInt(day.setHours(0,0,0)/1000).toString(16) + z;
    var idOfEndDay = parseInt(day.setHours(23,59,59)/1000).toString(16) + z;
    return [idOfBeginDAy,idOfEndDay, id];
}

var gen_hour_id = function(hours){
    var hour = new Date(parseInt(((new Date()).valueOf()/1000)-(hours*60*60))*1000);
    var id = hour.toLocaleFormat('%Y-%m-%d %H时');
    var z = '0000000000000000';
    var idOfBeginHour = parseInt(hour.setMinutes(0,0)/1000).toString(16) + z;
    var idOfEndHour = parseInt(hour.setMinutes(59,59)/1000).toString(16) + z;
    return [idOfBeginHour, idOfEndHour, id];
}

db.system.js.save({
    "_id" : "gen_day_id",
    "value" : gen_day_id
})

var gen_days_id = function(days){
    var z = '0000000000000000'
    var yesterday = new Date(parseInt(((new Date()).valueOf()/1000)-(24*60*60))*1000)
    var daysago = new Date(parseInt(((new Date()).valueOf()/1000)-(days*24*60*60))*1000)
    var idOfBeginDaysAgo = parseInt(daysago.setHours(0,0,0)/1000).toString(16) + z
    var idOfEndYesterday = parseInt(yesterday.setHours(23,59,59)/1000).toString(16) + z
    return [idOfBeginDaysAgo, idOfEndYesterday]
}

db.system.js.save({
    "_id" : "gen_days_id",
    "value" : gen_days_id
})

