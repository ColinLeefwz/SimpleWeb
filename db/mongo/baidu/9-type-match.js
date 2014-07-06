var type_match=db.mapabc_baidu_1.aggregate(
  { $match : { t : 1 } },
  { $project : {
     tm : 1,
     tb : 1,
  } },
  { $group : {
     _id : { tb:"$tb",tm : "$tm" },
     cc : { $sum : 1 },
  } },
  { $sort : { _id : 1, cc: -1 } }
);

type_match["result"].forEach(function(x,i,arr){
	var obj = {
		tb: x._id["tb"],
		tm: x._id["tm"],
		cc: x.cc
	}
	db.mapabc_baidu_type_match.insert(obj);
});

/*
db.mapabc_baidu_type_match.find({"tb" : "生活服务;宠物"},{_id:0}).sort({cc:-1})

{ "tb" : "生活服务;宠物", "tm" : "医疗保健服务;动物医疗场所;宠物诊所", "cc" : 1514 }
{ "tb" : "生活服务;宠物", "tm" : "医疗保健服务;动物医疗场所;兽医站", "cc" : 1152 }
{ "tb" : "生活服务;宠物", "tm" : "购物服务;专卖店;宠物用品店", "cc" : 716 }
{ "tb" : "生活服务;宠物", "tm" : "购物服务;购物相关场所;购物相关场所", "cc" : 622 }
{ "tb" : "生活服务;宠物", "tm" : "政府机构及社会团体;政府机关;区县级政府及事业单位", "cc" : 254 }
{ "tb" : "生活服务;宠物", "tm" : "医疗保健服务;动物医疗场所;动物医疗场所", "cc" : 251 }
{ "tb" : "生活服务;宠物", "tm" : "购物服务;花鸟鱼虫市场;宠物市场", "cc" : 229 }
{ "tb" : "生活服务;宠物", "tm" : "购物服务;专卖店;专营店", "cc" : 117 }
{ "tb" : "生活服务;宠物", "tm" : "政府机构及社会团体;政府机关;乡镇级政府及事业单位", "cc" : 67 }
{ "tb" : "生活服务;宠物", "tm" : "生活服务;生活服务场所;生活服务场所", "cc" : 57 }
{ "tb" : "生活服务;宠物", "tm" : "购物服务;花鸟鱼虫市场;花鸟鱼虫市场", "cc" : 55 }
{ "tb" : "生活服务;宠物", "tm" : "政府机构及社会团体;政府机关;地市级政府及事业单位", "cc" : 37 }
{ "tb" : "生活服务;宠物", "tm" : "公司企业;公司;公司", "cc" : 35 }
{ "tb" : "生活服务;宠物", "tm" : "政府机构及社会团体;公检法机构;公证鉴定机构", "cc" : 34 }
{ "tb" : "生活服务;宠物", "tm" : "医疗保健服务;疾病预防机构;疾病预防", "cc" : 13 }
{ "tb" : "生活服务;宠物", "tm" : "公司企业;农林牧渔基地;其它农林牧渔基地", "cc" : 11 }
{ "tb" : "生活服务;宠物", "tm" : "医疗保健服务;诊所;诊所", "cc" : 10 }
{ "tb" : "生活服务;宠物", "tm" : "政府机构及社会团体;政府机关;政府机关相关", "cc" : 9 }

db.mapabc_baidu_2.find({"tb" : "生活服务;宠物", "tm" : "购物服务;购物相关场所;购物相关场所"})
*/

/*
var type_match=db.mapabc_baidu_1.group(
           {key: { tm:true, tb:true },
            //cond: { active:1 },
            reduce: function(obj,prev) { prev.cc += 1; },
            initial: { cc: 0 }
            });
			
Mon Nov 26 14:12:19 uncaught exception: group command failed: {
	"errmsg" : "exception: group() can't handle more than 20000 unique keys",
	"code" : 10043,
	"ok" : 0
}
*/		