db.loadServerScripts();

var userDay = function(days){
    [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var ss={};
    var total = 0;
    var wb = 0;
    var qq =0;
    var album=0;
    var pic=0;
    var da = [];
	
    db.photos.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(photos){
        total += 1;
        if(photos.weibo==true)
            wb += 1;
        if(photos.qq==true)
            qq += 1;
        if(photos.t==1)
            pic += 1;
        if(photos.t==2)
            album += 1;	
        if(photos.room != undefined) {
            if(!ss[photos.room]){
                ss[photos.room] = 1;
            }else{
                ss[photos.room] += 1;
            }
        }
    })
	
    for(var sh in ss){
        da.push([parseInt(sh), ss[sh]])
    }

    da = da.sort(function(f,s){
        return s[1]-f[1]
    })
	
    db.photo_day_stats.insert({
        _id: id,
        wb: wb,
        qq: qq,
        total: total,
        pic: pic,
        album: album,
        shops: da.slice(0, 10)
    })
}

var count = function(days){
    for(var i = days; i > 0; i--){
        userDay(i)
    }
}

count(1)