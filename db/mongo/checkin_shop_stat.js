
var checkinShopStat = function(days){
    var z = '0000000000000000'
    var yesterday = new Date(parseInt(((new Date()).valueOf()/1000)-(24*60*60))*1000)
    var daysago = new Date(parseInt(((new Date()).valueOf()/1000)-(days*24*60*60))*1000)
    var idOfBeginYesterday = parseInt(daysago.setHours(0,0,0)/1000).toString(16) + z
    var idOfEndYesterday = parseInt(yesterday.setHours(23,59,59)/1000).toString(16) + z

    db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginYesterday),
            $lt: ObjectId(idOfEndYesterday)
        },
        del: {
            $exists: false
        }
    }).forEach(function(checkin){
        var us ={};
        var ips = {};
    
        var ciss =  db.checkin_shop_stats.findOne({
            _id: checkin.sid
        })

        if(!ciss){
            db.checkin_shop_stats.insert({
                _id: checkin.sid,
                users: us,
                ips: ips
            })
        }

        ciss =  db.checkin_shop_stats.findOne({
            _id: checkin.sid
        })
    
        us = ciss.users
        ips = ciss.ips
        if(!us[checkin.uid]){
            us[checkin.uid] = [1, checkin._id];
        }else{
            us[checkin.uid] = [us[checkin.uid][0] + 1, checkin._id];
        }


        if(checkin.ip.indexOf(',') == -1){
            var ip = checkin.ip.replace('.', '/', 'g')
            if(!ips[ip]){
                ips[ip] = [1, checkin._id];
            }else{
                ips[ip] = [ips[ip][0] + 1, checkin._id];
            }
        }

        db.checkin_shop_stats.update({
            _id: checkin.sid
        }, {
            $set: {
                users: us,
                ips: ips
            }
        })
       

    })

    total_users()
}


var total_users = function(){
    db.checkin_shop_stats.find().forEach(function(css){
        var total_users = 0;
        var total_checkins = 0;
        var users = css.users;
        for(var user in users){
            total_users += 1;
            total_checkins += users[user][0]
        }

        db.checkin_shop_stats.update({
            _id: css._id
        }, {
            $set: {
                utotal: total_users,
                ctotal: total_checkins
            }
        })

    })
}


checkinShopStat(1)








