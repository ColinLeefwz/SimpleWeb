db.loadServerScripts();

var checkinShopAlt = function(months){

    //月份的起始id和截止id
    var d = new Date();
    var z = '0000000000000000';
    endOfMonth = new Date(d.setFullYear(d.getFullYear(), d.getMonth()+1-months, -1))
    idOfEndMonth = parseInt(endOfMonth.setHours(23, 59, 59)/1000).toString(16)+z;
    beginOfMonth = new Date(d.setFullYear(d.getFullYear(), d.getMonth(), 1));
    idOfBeginMonth = parseInt(beginOfMonth.setHours(0, 0, 0)/1000).toString(16)+z;

    var datas = [];
    cond = {
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
    }

    var tmp_datas = db.checkins.group({
        "key" : {
            sid: true
        },
        initial:{
            talt: 0,
            taltacc: 0,
            count: 0,
            avgalt: 0,
            avgaltacc: 0
        },
        "$reduce" : function(doc, prev) {
            prev.count += 1;
            prev.talt += doc.alt;
            prev.taltacc += doc.altacc;
        },
        "cond" : cond,
        finalize:function(out){
            out.avgalt = out.talt/out.count;
            out.avgaltacc = out.taltacc/out.count;
        }

    });

    tmp_datas.forEach(function(data){
        cond["sid"] = data.sid;
        pffcalt = 0;
        pffcaltacc = 0;
        db.checkins.find(cond).forEach(function(checkin){
            pffcalt += (checkin.alt - data.avgalt)*(checkin.alt - data.avgalt)
            pffcaltacc += (checkin.altacc - data.avgaltacc)*(checkin.altacc - data.avgaltacc)
        })
        max = db.checkins.find(cond).sort({
            alt: -1,
            altacc: -1
        })[0];
        min = db.checkins.find(cond).sort({
            alt: 1,
            altacc: 1
        })[0];
       
        datas.push({
            "_id": data.sid,
            'max': [max.alt, max.altacc],
            'min': [min.alt, min.altacc],
            "fcalt": Math.sqrt(pffcalt),
            'fcaltacc': Math.sqrt(pffcaltacc),
            "avgalt" : data.avgalt,
            "avgaltacc" :data.avgaltacc
        })
    })
    var id = d.toLocaleFormat('%Y-%m')
    db.checkin_shop_alts.insert({
        _id: id,
        datas: datas
    })

}

function cycleCheckinShopAlt(months){
    for(var i = months; i > 0; i--){
        checkinShopAlt(i);
    }
}

cycleCheckinShopAlt(1)

