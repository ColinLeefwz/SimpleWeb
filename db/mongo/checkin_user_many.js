db.loadServerScripts();
var checkinUserMany = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var tmpGroupCheckins = {}
    var data = {}
    db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        },
        del: {
            $exists: false
        }
    }).sort({
        _id: 1
    }).forEach(function(checkin){
        if(!tmpGroupCheckins[checkin.uid.valueOf()]){
            tmpGroupCheckins[checkin.uid.valueOf()] = [checkin._id]
        }
        else{
            tmpGroupCheckins[checkin.uid.valueOf()].push(checkin._id)
        }
    })
    //3分钟内三次签到判断为多次签到.
    for(var tgc in tmpGroupCheckins){
        var checkinIds = tmpGroupCheckins[tgc]
        if(checkinIds.length >= 3){
            for(var i=0; i < checkinIds.length-2; i++){
                bt = parseInt(checkinIds[i].valueOf().slice(0, 8), 16)
                et = parseInt(checkinIds[i+2].valueOf().slice(0, 8), 16)
                if((et-bt) < 180){
                    if(!data[tgc]){
                        data[tgc] = [[checkinIds[i],checkinIds[i+1],checkinIds[i+2]]]
                    }
                    else{
                        last = data[tgc][data[tgc].length -1]
                        if(last.indexOf(checkinIds[i]) == -1){
                            data[tgc].push([checkinIds[i],checkinIds[i+1],checkinIds[i+2]])
                        }
                        else{
                            last.push(checkinIds[i+2])
                        }
                    }
                }
            }
        }
    }
    db.checkin_user_manies.insert({
        _id: id,
        data: data
    })
}

var cycleCheckinUserMany = function(days){
    for(var i = days; i > 0; i--){
        checkinUserMany(i)
    }
}

cycleCheckinUserMany(1)