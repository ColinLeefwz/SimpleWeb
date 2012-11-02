db.loadServerScripts();

var userDay = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var mtotal = 0;
    var ftotal = 0;
    var total = 0;

    db.users.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(user){
        total += 1;
        if(user.gender==1)
            mtotal += 1;
        if(user.gender==2)
            ftotal += 1;
    })

    db.user_days.insert({
        _id: id,
        mtotal: mtotal,
        ftotal: ftotal,
        total: total
    })
}

var count = function(days){
    for(var i = days; i > 0; i--){
        userDay(i)
    }
}

count(10)



