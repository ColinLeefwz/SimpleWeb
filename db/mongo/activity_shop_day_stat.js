db.loadServerScripts();

Array.prototype.S=String.fromCharCode(2);  
Array.prototype.in_array=function(e){  
	var r=new RegExp(this.S+e+this.S);  
	return (r.test(this.S+this.join(this.S)+this.S));  
}

var cs={};
var m1={};
var m2={};
var activityShopDayStats = function(days){
    var [idOfBeginDay,idOfEndDay, id] = gen_day_id(days);
    var ntravel = 0,
        nmansion1 = 0,
        nmansion2 = 0,
        ncooperation_shops = 0;


// 合作框架广告推送楼宇地点
var mansion1 = [20297588,21833286,10437415,20344589,10442142,10447101,21833609,20297721,
20297831,20338155,20297832,7043994,20297708,20325453,20297552]
// 重点推送楼宇地点
var mansion2 = [6544448,10462223,10434468,20324623,21833620,20325399,21828719,20325475,10453425,20325313,2033286,20297541,20325425,10436966,20297536,20325455,
21833626,20297628,20325398,10434661,20344567,20297735,20297534,20325478,20325454,20297710,10447108,10452118,10443607,10412686,10415679,21833701,
20325394,20298195,6517315,20325438,20297694,10440563,20297810,20325312,20344565,20344552]
// 合作商家
var cooperation_shops = [21833121,	21832395,	21617616,	21832993,	1204513,	21616891,	6564061, 	21619457,	21828387,	21615523,
	21625070,	21616160,	21833151,	21615581,	21829139,	21830285,	1229283,	21625903,	21616840,	21833289,
	21833623,	21624812,	21833354, 21833342,	21617846,	21617897,	21626213,	21830697,	21626809,	21833416,	1204520]

   db.checkins.find({
        _id: {
            $gt: ObjectId(idOfBeginDay),
            $lt: ObjectId(idOfEndDay)
        }
    }).forEach(function(checkin){
        db.users.find({
            _id: {
                $gt: ObjectId(idOfBeginDay),
                $lt: ObjectId(idOfEndDay)
            },
            _id: checkin.uid            
        }).forEach(function(user){
            if (mansion1.in_array(checkin.sid)){
                nmansion1 += 1
                if(!m1[checkin.sid]){
                    m1[checkin.sid] = 1;
                }else{
                    m1[checkin.sid] += 1;
                }
            }

            if (mansion2.in_array(checkin.sid)){
                nmansion2 += 1
                if(!m2[checkin.sid]){
                    m2[checkin.sid] = 1;
                }else{
                    m2[checkin.sid] += 1;
                }
            }
            if (cooperation_shops.in_array(checkin.sid)){
                ncooperation_shops += 1
                if(!cs[checkin.sid]){
                    cs[checkin.sid] = 1;
                }else{
                    cs[checkin.sid] += 1;
                }
            }
        })
    })

    db.activity_shop_day_stats.insert({
        _id: id,
        mansion1:m1,
        mansion2:m2,
        cooperation_shops:cs,
        m1num: nmansion1,
        m2num: nmansion2,
        csnum: ncooperation_shops
    })
}

var cds = function(days){
    for(var i = days; i > 0; i--){
        activityShopDayStats(i)
    }
}
cds(1)