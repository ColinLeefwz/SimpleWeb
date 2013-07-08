db.loadServerScripts();

var userHour = function(hours){
	[idOfBeginHour, idOfEndHour, id] = gen_hour_id(hours);
	var mtotal = 0;
    var ftotal = 0;
    var total = 0;
    var wb = 0;
	var qq =0;

	db.users.find({
		_id: {
			$gt: ObjectId(idOfBeginHour),
			$lt: ObjectId(idOfEndHour)
		}
	}).forEach(function(user){
        total += 1;
        if(user.gender==1)
            mtotal += 1;
        if(user.gender==2)
            ftotal += 1;
    })

	db.users.find({
	    _id: {
		     $gt: ObjectId(idOfBeginHour),
			 $lt: ObjectId(idOfEndHour)
		}
	}).forEach(function(user){
        if(user.wb_uid!=null)
             wb += 1;
        if (user.qq!=null)
             qq += 1;
    })

    db.user_hours.insert({
        _id: id,
        mtotal: mtotal,
        ftotal: ftotal,
		wb: wb,
		qq: qq,
        total: total
    })   
}

var count = function(hours){
    for(var i = hours; i > 0; i--){
        userHour(i)
    }
}

count(1)