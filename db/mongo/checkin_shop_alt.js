db.loadServerScripts();

var checkinShopAlt = function(months){
    // 清空mapReduce的临时文件
    db.tmp_checkin_shop_alt.remove();

    //月份的起始id和截止id
    var d = new Date();
    var z = '0000000000000000';
    endOfMonth = new Date(d.setFullYear(d.getFullYear(), d.getMonth()+1-months, -1))
    idOfEndMonth = parseInt(endOfMonth.setHours(23, 59, 59)/1000).toString(16)+z;
    beginOfMonth = new Date(d.setFullYear(d.getFullYear(), d.getMonth(), 1));
    idOfBeginMonth = parseInt(beginOfMonth.setHours(0, 0, 0)/1000).toString(16)+z;

    m = function() {
        emit(this.sid, {
            _id: this._id,
            count: 1,
            alt: parseInt(this.alt),
            altacc: parseInt(this.altacc)
        })
    }
    r = function(key, values) {
        var talt = 0;
        var count = 0;
        var taltacc =0;
        var avgalt = 0;
        var avgaltacc =0;
        var pfalt = 0;
        var pfaltacc =0;
        var fcalt =0;
        var fcaltacc = 0;
        var maxalt = (values[0] ? values[0].alt : 0);
        var max = (values[0] ? [values[0].alt, values[0].altacc ] : [0, 0])
        var minalt = (values[0] ? values[0].alt : 0);
        var min = (values[0] ? [values[0].alt, values[0].altacc ] : [0, 0])
        values.forEach(function(v) {
            count += v.count;
            talt += v.alt;
            taltacc += v.altacc;
            if(v.alt > maxalt){
                maxalt = v.alt;
                max = [v.alt, v.altacc]
            }
            if(v.alt< minalt)
            {
                minalt = v.alt;
                min = [v.alt, v.altacc]
            }
        });
        avgalt = talt/count;
        avgaltacc = taltacc/count;
        values.forEach(function(v) {
            pfalt += (v.alt - avgalt)*(v.alt - avgalt);
            pfaltacc += (v.altacc - avgaltacc)*(v.altacc - avgaltacc)
        });
        fcalt = Math.sqrt(pfalt);
        fcaltacc = Math.sqrt(pfaltacc);
        return {
            _id: key,
            max: max,
            min: min,
            avgalt: avgalt,
            avgaltacc: avgaltacc,
            fcalt: fcalt,
            fcaltacc: fcaltacc
        };
    }
    db.checkins.mapReduce(m, r, {
        query:{
            _id: {
                $gt: ObjectId(idOfBeginMonth),
                $lt: ObjectId(idOfEndMonth)
            },
            del: {
                $exists: false
            },
            alt: {
                $exists: true,
                $ne: 0
            },
            altacc: {
                $ne: -1
            }
        },
        out : "tmp_checkin_shop_alt"
    } );

    var id = d.toLocaleFormat('%Y-%m-%d')
    var datas = []

    db.tmp_checkin_shop_alt.find().forEach(function(csa){
        datas.push(csa.value)
    })

    db.checkin_shop_alts.insert({
        _id: id,
        datas: datas
    })

}



function cycleCheckinShopAlt(months){
    db.checkin_shop_alts.remove()
    for(var i = months; i > 0; i--){
        checkinShopAlt(i);
    }
}

cycleCheckinShopAlt(2)





