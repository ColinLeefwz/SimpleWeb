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
                shops: []
            })
        }

        cips =  db.checkin_ip_stats.findOne({
            _id: checkin.ip
        })

        var ctl = cips.ctotal + 1
        var stl = cips.stotal
        var shs = cips.shops
        var index = 0
        var exist = false

        for(var sh in shs){
            if(shs[sh]['sid'] == checkin.sid){
                index = sh
                exist = true
                break
            }
        }

        if(exist){
            shs[index]['time'] = checkin._id
        }
        else
        {
            stl += 1;
            shs.push({
                sid: checkin.sid,
                time: checkin._id
            })
        }

        db.checkin_ip_stats.update({
            _id: checkin.ip
        }, {
            $set: {
                ctotal: ctl,
                stotal: stl,
                shops: shs
            }
        })
    })
}

checkinIpStat(1)

