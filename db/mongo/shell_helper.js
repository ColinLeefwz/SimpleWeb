
var last = function(col_name){
	return eval("db."+col_name+".find().sort({_id:-1}).limit(1)");
}

var first = function(col_name){
	return eval("db."+col_name+".find().sort({_id:1}).limit(1)");
}


db.system.js.save({ "_id" : "last", "value" : last })
db.system.js.save({ "_id" : "first", "value" : first })


var gen_days_id =function(days){
	var yesterday = new Date(parseInt(((new Date()).valueOf()/1000)-(days*24*60*60))*1000);
  var id = yesterday.toLocaleFormat('%Y-%m-%d');
  var z = '0000000000000000';
  var idOfBeginYesterday = parseInt(yesterday.setHours(0,0,0)/1000).toString(16) + z;
  var idOfEndYesterday = parseInt(yesterday.setHours(23,59,59)/1000).toString(16) + z;
  return [idOfBeginYesterday,idOfEndYesterday];
}