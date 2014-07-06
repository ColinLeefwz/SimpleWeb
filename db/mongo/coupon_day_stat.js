db.loadServerScripts();
var couponDayStat = function(days){
    [idOfBeginDay,idOfEndDay, day] = gen_day_id(days);
    db.coupon_downs.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(coupon_down){
        var cdss =  db.coupon_day_stats.findOne({
            sid: coupon_down.sid,
            day: day
        });
        if(!cdss){
            db.coupon_day_stats.insert({
                sid: coupon_down.sid,
                day: day,
                dcount: 0,
                ucount: 0,
                data: {}
            });
        }
        cdss =  db.coupon_day_stats.findOne({
            sid: coupon_down.sid,
            day: day
        });
        var uc = coupon_down.uat ? 1 : 0;
        var dcount = cdss.dcount +1;
        var ucount = cdss.ucount + uc;
        var data = cdss.data;
        var ca = data[coupon_down.cid.str];
        if(!ca){
            data[coupon_down.cid.str] = [1, 0+uc]
        }
        else{
            ca[0] += 1;
            ca[1] += uc
        }
        db.coupon_day_stats.update({
            _id: cdss._id
        },{
            $set: {
                dcount: dcount,
                ucount: ucount,
                data: data
            }
        });
    })
}

var cds = function(days){
    for(var i = days; i > 0; i--){
        couponDayStat(i)
    }
}
cds(1)

