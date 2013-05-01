db.loadServerScripts();
var userDeviceStat = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    db.user_devices.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(user_device){
        var udss = db.user_device_stats.findOne({
            _id: id
        });
        if(!udss){
            db.user_device_stats.insert({
                _id: id,
                cios: 0,
                card: 0
            });
        }
        udss = db.user_device_stats.findOne({
            _id: id
        });
        var cios = udss.cios;
        var card = udss.card;
        var ds = user_device.ds[0];
        var isopatrn=/^iOS/i;
        var ardpatrn=/^android/i;
        if(ardpatrn.exec(ds[1]))
            card+=1;
        if(isopatrn.exec(ds[1]))
            cios +=1;
        db.user_device_stats.update({
            _id: udss._id
        },{
            "$set" : {
                cios: cios,
                card: card
            }
        });
    })
}

var uds = function(days){
    for(var i = days; i > 0; i--){
        userDeviceStat(i)
    }
}
uds(1)