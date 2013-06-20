db.loadServerScripts();

var userDayActive = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var mulogo = 0;
    var mufollow = 0;
    var fulogo = 0;
    var fufollow = 0;
    var muserPcountSum2 = 0, fuserPcountSum2 = 0;
    var muserDayTotal = 0, fuserDayTotal = 0;
    var muserFollowTotal2 = 0, fuserFollowTotal2 = 0; 
    
    db.users.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(user){
        if (1 == user.gender) {
          var muserPcountSum = user.pcount
          muserPcountSum2 += muserPcountSum
        }

        if (2 == user.gender) {
          var fuserPcountSum = user.pcount
          fuserPcountSum2 += fuserPcountSum
        }
    })

    db.user_days.find({
        _id: id
    }).forEach(function(user_day){
        muserDayTotal = user_day.mtotal
        fuserDayTotal = user_day.ftotal

    })
    
    db.user_follows.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(user_follow){
        var muserFollowTotal = user_follow.follows.length
        muserFollowTotal2 += muserFollowTotal
    })
     
    
    db.user_day_active.insert({
        _id: id,
        mulogo: muserPcountSum2/muserDayTotal,
        fulogo: fuserPcountSum2/fuserDayTotal,
        mufollow: muserFollowTotal2/muserDayTotal,
        fufollow: muserFollowTotal2/fuserDayTotal
    })
}

var count = function(days){
    for(var i = days; i > 0; i--){
        userDayActive(i)
    }
}

count(1)



