db.loadServerScripts();

var checkinUserStat = function(days){
    var idOfBeginDaysAgo;
    var idOfEndYesterday;
    [idOfBeginDaysAgo, idOfEndYesterday] = gen_days_id(days);
    db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginDaysAgo),
            $lt: ObjectId(idOfEndYesterday)
        },
        del: {
            $exists: false
        }
    }).forEach(function(checkin){
        var all;
        var l3=[];
        var city = db.shops.findOne({
            _id: checkin.sid
        }).city
        var ciss =  db.checkin_user_stats.findOne({
            _id: checkin.uid
        })
        if(!ciss){
            db.checkin_user_stats.insert({
                _id: checkin.uid,
                all: 0,
                l3: []
            })
        }
        ciss =  db.checkin_user_stats.findOne({
            _id: checkin.uid
        })
        all = ciss.all + 1;
        l3 = ciss.l3
        l3.unshift({
            id: checkin._id,
            city: city
        })
        l3 = l3.slice(0,3)
        db.checkin_user_stats.update({
            _id: checkin.uid
        }, {
            $set: {
                all: all,
                l3: l3
            }
        })
    })
}

checkinUserStat(1);









