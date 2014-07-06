db.loadServerScripts();

var userDeviceDay = function(days){
    [idOfBeginDAy,idOfEndDay, id] = gen_day_id(days);
    var ios = {}, ard = {};
    var cios = 0, card = 0;
    db.user_devices.find({
        _id: {
            $gt: ObjectId(idOfBeginDAy),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(user_device){

        var ds = user_device.ds[0][1].replace(/\./g,"-");
        var isopatrn=/^iOS/i,
            ardpatrn=/^android/i;
        if(ardpatrn.exec(ds)){
            card += 1
        }
        if(isopatrn.exec(ds)){
            cios += 1
        }            
        if(!ardpatrn.exec(ds)){
            if(isopatrn.exec(ds) && !ios[ds]){
                ios[ds] = 1
            }else{
                ios[ds] += 1
            }
        }
        if(!isopatrn.exec(ds)){
            if(ardpatrn.exec(ds) && !ard[ds]){
                ard[ds] = 1
            }else{
                ard[ds] += 1
            }
        }
    });
    db.user_device_stats.insert({
            _id: id,
            card: card,
            cios: cios,
            ios: ios,
            ard: ard
    });
}

var uds = function(days){
    for(var i = days; i > 0; i--){
        userDeviceDay(i)
    }
}
uds(1)