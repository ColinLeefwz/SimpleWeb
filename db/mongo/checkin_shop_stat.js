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
    
        var ciss =  db.checkin_shop_stats.findOne({
            _id: checkin.sid
        })

        if(!ciss){
            db.checkin_shop_stats.insert({
                _id: checkin.sid,
                users: us
            })
        }

        ciss =  db.checkin_shop_stats.findOne({
            _id: checkin.sid
        })
    
        us = ciss.users;
        if(!us[checkin.uid.str]){
			//这里的更改导致数据不兼容：checkin.uid!=checkin.uid.str, ObjectId("x") => x
            us[checkin.uid.str] = [1, checkin._id, checkin.sex];
        }else{
            us[checkin.uid.str] = [us[checkin.uid.str][0] + 1, checkin._id, checkin.sex];
        }

        db.checkin_shop_stats.update({
            _id: checkin.sid
        }, {
            $set: {
                users: us
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
    db.shop_sina_users.find().forEach(function(x){
        ssuc =x.users.length;
        if(ssuc==0) return;
        db.shops.update({
            _id: x._id,
            utotal:0
        }, {
            $set: {
                utotal: ssuc,
                uftotal: ssuc/2
            }
        })		
    })
    db.checkin_shop_stats.find().forEach(function(x){
        ssu = db.shop_sina_users.findOne({
            _id: x._id
        });
        if(ssu!=null) ssuc =ssu.users.length;
        else ssuc=0;
        db.shops.update({
            _id: x._id
        }, {
            $set: {
                utotal: x.utotal+ssuc,
                uftotal: x.uftotal+ssuc/2
            }
        })
    })
}

checkinShopStat(1);
//sync_to_shops(); //将计算获得的商家用户统计数据写回商家表，以方便按用户数排序。








