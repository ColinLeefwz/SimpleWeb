db.loadServerScripts();

var checkinIpStat = function(days){
    var idOfBeginDaysAgo;
    var idOfEndYesterday;
    [idOfBeginDaysAgo, idOfEndYesterday] = gen_days_id(days)
    db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginDaysAgo),
            $lt: ObjectId(idOfEndYesterday)
        },
        ip: {
            $not: /,/
        },
        del: {
            $exists: false
        }
    }).forEach(function(checkin){

        var cips =  db.checkin_ip_stats.findOne({
            _id: checkin.ip
        })

        if(!cips){
            db.checkin_ip_stats.insert({
                _id: checkin.ip,
                ctotal: 0,
                stotal: 0,
                utotal: 0,
                shops: [],
                users: []
            })
        }

        cips =  db.checkin_ip_stats.findOne({
            _id: checkin.ip
        })

        if(cips.stotal < 20){
            var ctl = cips.ctotal + 1
            var stl = cips.stotal
            var utl = cips.utotal
            var shs = cips.shops
            var users = cips.users
            var sindex = 0
            var uindex = 0
            var sexist = false
            var uexist = false

            for(var sh in shs){
                if(shs[sh]['sid'] == checkin.sid){
                    sindex = sh
                    sexist = true
                    break
                }
            }

            if(sexist){
                shs[sindex]['time'] = checkin._id
            }
            else
            {
                stl += 1;
                shs.push({
                    sid: checkin.sid,
                    time: checkin._id
                })
            }

            for(var user in users){
                if(db.users.findOne({_id: users[user]['uid']}).wb_uid == db.users.findOne({_id: checkin.uid}).wb_uid){
                    uindex = user
                    uexist = true
                    break
                }
            }

            if(uexist){
                users[uindex]['time'] = checkin._id
            }
            else
            {
                utl += 1;
                users.push({
                    uid: checkin.uid,
                    time: checkin._id
                })
            }


            db.checkin_ip_stats.update({
                _id: checkin.ip
            }, {
                $set: {
                    ctotal: ctl,
                    stotal: stl,
                    utotal: utl,
                    shops: shs,
                    users: users
                }
            })
        }
    })
}

checkinIpStat(1)

