db.loadServerScripts();

var findCheckins = function(idOfBeginDay,idOfEndDay){
    return  db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        },
        acc: {
            $exists: true
        },
        del: {
            $exists: false
        }
    })
}

var checkinLocAcc = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);

    var checkins = findCheckins(idOfBeginDay,idOfEndDay)
    var max = checkins[0] ? checkins[0].acc : 0
    var min = checkins[0] ? checkins[0].acc : 0
    var tacc = 0;
    var pffc = 0;
    var count = 0;
    var avg = 0;
    var fc = 0;

    findCheckins(idOfBeginDay,idOfEndDay).forEach(function(checkin){
        tacc += checkin.acc;
        count += 1;
        max = (checkin.acc > max ? checkin.acc : max)
        min = (checkin.acc < min ? checkin.acc : min)
    })
    avg = (count == 0 ? 0 :tacc/count)
    findCheckins(idOfBeginDay,idOfEndDay).forEach(function(checkin){
        pffc += (checkin.acc-avg)*(checkin.acc-avg)
    })
    fc = Math.sqrt(pffc)
    db.checkin_loc_accs.insert({
        _id:id,
        max: max,
        min: min,
        avg: avg,
        fc: fc
    })
}

var cycleCheckinLocAcc = function(days){
    for(var i = days; i > 0; i--){
        checkinLocAcc(i)
    }
}

cycleCheckinLocAcc(1)

