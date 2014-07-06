db.loadServerScripts();

var set_user_city = function(){
    db.users.find({
        city:{
            $exists: false
        },
        auto:{
            $exists: false
        }
    }).forEach(function(user){
        db.checkins.find({
            uid: user._id
        }).sort({
            _id: 1
        }).limit(1).forEach(function(ch){
            db.users.update({
                _id: user._id
            },{
                $set:{
                    city: ch.city
                }
            });
        });
    })
};


var userCityDay = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var datas = {}
    db.users.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        },
        city:{
            $exists: true
        },
        auto:{
            $exists: false
        }
    }).forEach(function(user){
        if(!datas[user.city]){
            datas[user.city] = 1
        }else{
            datas[user.city] += 1
        }
    })
    db.user_city_days.insert({
        _id: id,
        datas: datas
    })
}

var cityAndDay = function(days){
    set_user_city()
    for(var i = days; i > 0; i--){
        userCityDay(i)
    }
}

cityAndDay(1)