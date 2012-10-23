db.loadServerScripts();

var checkinShopStat = function(days){
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
    
        us = ciss.users;
        ips = ciss.ips;
        if(!us[checkin.uid]){
            us[checkin.uid] = [1, checkin._id, checkin.sex];
        }else{
            us[checkin.uid] = [us[checkin.uid][0] + 1, checkin._id, checkin.sex];
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
    total_users();
}


var total_users = function(){
    db.checkin_shop_stats.find().forEach(function(css){
        var total_users = 0;
        var female_users = 0;
        var total_checkins = 0;
        var users = css.users;
        for(var user in users){
            total_users += 1;
            if(users[user][2]==2) female_users +=1;
            total_checkins += users[user][0];
        }

        db.checkin_shop_stats.update({
            _id: css._id
        }, {
            $set: {
                utotal: total_users,
                uftotal: female_users,
                ctotal: total_checkins
            }
        })

    })
}


var sync_to_shops = function(){
    db.checkin_shop_stats.find().limit(1).forEach(function(x){
        db.shops.update({
            _id: x._id
        }, {
            $set: {
                utotal: x.utotal,
                uftotal: x.uftotal
            }
        })
    })
}

checkinShopStat(1);
sync_to_shops(); //将计算获得的商家用户统计数据写回商家表，以方便按用户数排序。








