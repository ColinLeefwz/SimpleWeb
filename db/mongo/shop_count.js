//按城市,省份统计商家
var groupShop = function(){
    db.shops.group({
        "key":{
            city: true
        },
        initial:{
            count: 0
        },
        "$reduce" : function(doc, prev) {
            prev.count += 1
        }
    }).forEach(function(g){
        db.code_count_shops.insert({
            _id: g['city'],
            count: g['count']
        })
    });
    var groupS = {} ;
    // 区号统计
    db.cities.find().forEach(function(city){
        if(!groupS[city.s]){
            groupS[city.s] = [city.code]
        }else{
            groupS[city.s].push(city.code)
        }
    });
    for(var s in groupS){
        var scount =0;
        db.code_count_shops.find({
            _id: {
                $in: groupS[s]
            }
        }).forEach(function(ccs){
            scount += ccs.count
        });
        db.s_count_shops.insert({
            _id: s,
            count: scount
        })
    }
}

groupShop()

