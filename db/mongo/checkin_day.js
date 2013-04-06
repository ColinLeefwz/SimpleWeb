db.loadServerScripts();

var checkinDay = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var ss={};
    var num=0, od1=0, od2=0,od3=0;
    var da = [];

    db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        },
        del: {
            $exists: false
        }
    }).forEach(function(checkin){
        num+=1;
        if(checkin.od==1) od1 += 1;
        if(checkin.od==2) od2 += 1;
        if(checkin.od==3) od3 += 1;
        if(checkin.sid != undefined) {
            if(!ss[checkin.sid]){
                ss[checkin.sid] = 1;
            }else{
                ss[checkin.sid] += 1;
            }
        }
    }
    );

    for(var sh in ss){
        da.push([parseInt(sh), ss[sh]])
    }

    da = da.sort(function(f,s){
        return s[1]-f[1]
    })

    db.checkin_days.insert({
        num: num,
        od1: od1,
        od2: od2,
        od3: od3,
        shops: da.slice(0, 10),
        _id: id
    })
}


var filterAndCount = function(days){
	db.checkins.remove({acc:5,alt:0});
	db.checkins.remove({del:true});
    for(var i = days; i > 0; i--){
        checkinDay(i)
    }
}



filterAndCount(1)


