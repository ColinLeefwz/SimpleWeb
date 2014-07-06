db.loadServerScripts();

var shopDayTotalStats = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var cdcount = 0,
        cucount = 0,
        ctcount = 0,
        sdcount = 0,
        sucount = 0,
        stcount = 0;
    var cities = {};
    var da = [];

    db.coupon_downs.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(coupon_down){

        var uc = coupon_down.uat ? 1 : 0;
        var cs = db.coupons.findOne({
            _id: ObjectId(coupon_down.cid.str)
        })
        var t = cs.t2;
        if (1 == t){
            cdcount += 1;
            cucount += uc; 
        }else{
            sdcount += 1;
            sucount += uc;
        }
    })

    db.coupons.find({
        _id :{
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(coupon){
        var t = coupon.t2
        if ( 1 == t ){
            ctcount += 1
        }

        if ( 2 == t ){
            stcount += 1
        }
    })

    var cds = db.checkin_days.findOne({
        _id: id
    })
    var cnum = cds.num

    db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        },
        del: {
            $exists: false
        }
    }).forEach(function(checkin){
        if(checkin.sid != undefined) {
            var shop = db.shops.findOne({
                _id: checkin.sid
            })
            if(!cities[shop.city]){
                cities[shop.city] = 1;
            }else{
                cities[shop.city] += 1;
            }
        }
    })

    for(var cs in cities){
        da.push([cs, cities[cs]])
    }

    da = da.sort(function(f,s){
        return s[1]-f[1]
    })

    db.shop_day_total_stats.insert({
        _id: id,
        cucount: cucount,
        cdcount: cdcount,
        ctcount: ctcount,
        sucount: sucount,
        sdcount: sdcount,
        stcount: stcount,
        cnum: cnum,
        cities: da.slice(0, 10)
    })
}

var cds = function(days){
    for(var i = days; i > 0; i--){
        shopDayTotalStats(i)
    }
}
cds(1)

