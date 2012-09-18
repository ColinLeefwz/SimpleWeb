var checkinDay = function(days){
    var yesterday = new Date(parseInt(((new Date()).valueOf()/1000)-(days*24*60*60))*1000)
    var id = yesterday.toLocaleFormat('%Y-%m-%d')
    var z = '0000000000000000'

    var idOfBeginYesterday = parseInt(yesterday.setHours(0,0,0)/1000).toString(16) + z
    var idOfEndYesterday = parseInt(yesterday.setHours(23,59,59)/1000).toString(16) + z
    var ss={};
    var num=0, od1=0, od2=0,od3=0;
    var da = [];


    db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginYesterday),
            $lt: ObjectId(idOfEndYesterday)
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
        da.push([sh, ss[sh]])
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

var i =1;
for(i; i > 0; i--){
    checkinDay(i)
}