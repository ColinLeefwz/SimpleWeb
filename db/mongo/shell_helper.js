
var last = function(col_name){
	return eval("db."+col_name+".find().sort({_id:-1}).limit(1)");
}

var first = function(col_name){
	return eval("db."+col_name+".find().sort({_id:1}).limit(1)");
}


db.system.js.save({ "_id" : "last", "value" : last })
db.system.js.save({ "_id" : "first", "value" : first })

