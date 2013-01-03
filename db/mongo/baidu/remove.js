db.shops.remove({name:"商铺"})
db.shops.remove({name:"平价超市"})
db.shops.remove({name:"杂货店"})
db.shops.remove({name:"五金店"})
db.shops.remove({name:"服装店"})
db.shops.remove({name:"士多店"})
db.shops.remove({name:"日杂店"})
db.shops.remove({name:"服饰店"})
db.shops.remove({name:"书店"})
db.shops.remove({name:"鞋店"})
db.shops.remove({name:"烟酒副食店"})
db.shops.remove({name:"小吃店"})
db.shops.remove({name:"茶室"})
db.shops.remove({name:"烟酒茶"})
db.shops.remove({name:"检票处"})
db.shops.remove({name:"商店"})
db.shops.remove({name:"主食店"})
db.shops.remove({name:"提示牌"})
db.shops.remove({name:"衣橱"})
db.shops.remove({name:"修车亭"})
db.shops.remove({name:"栗子王"})
db.shops.remove({name:"棋牌室"})
db.shops.remove({name:"烤串"})
db.shops.remove({name:"鞋柜"})
db.shops.remove({name:"食品店"})
db.shops.remove({name:"食堂"})
db.shops.remove({name:"火锅"})
db.shops.remove({name:/停车场$/})
db.shops.remove({name:/批发$/})
db.shops.remove({type:/^金融/,name:/支行/})
db.shops.remove({type:/^金融/,name:/分理/})
db.shops.remove({name:/创业投资/})
db.shops.remove({name:/卫生站$/})
db.shops.remove({name:/村委会/})
db.shops.remove({name:/[0-9]+号楼$/})
db.shops.remove({name:/[a-zA-Z]+座$/})
db.shops.remove({name:/[0-9]+号$/})
db.shops.remove({name:/[0-9]+号[甲乙丙丁]+$/})
db.shops.remove({name:/[0-9]+幢$/})
db.shops.count({city:"010",name:/路[0-9]+号/})


db.shops.remove({name:/代购店/})
db.shops.remove({name:/代购点/})
db.shops.remove({name:/票/})
db.shops.remove({name:/厕/})
db.shops.remove({name:"住宅"})
db.shops.remove({name:/可以/})
db.shops.remove({"name" : "味道越来越不如以前"})
db.shops.remove({"name" : "感觉量越来越少了"})

db.shops.remove({name:/生殖健康中心$/})
db.shops.remove({type:"生活服务",name:/医院$/})
db.shops.remove({type:"生活服务",name:/口腔$/})

db.shops.remove({name:/复印/})
db.shops.remove({name:/修配/})
db.shops.remove({name:/彩扩/})

db.shops.remove({name:/设计工程/})
db.shops.remove({name:/配件/})
db.shops.remove({name:/装潢/})
db.shops.remove({name:/公关策划/})

db.shops.remove({name:/图文快印/})
db.shops.remove({name:/图文设计/})
db.shops.remove({name:/装饰工程/})
db.shops.remove({name:/经销/})
db.shops.remove({name:/香烟/})

db.shops.remove({name:/商行$/})
db.shops.remove({name:/电子$/})

db.shops.remove({name:/烟酒/})
db.shops.remove({name:/奶茶/})
db.shops.remove({name:/维修/})
db.shops.remove({name:/广告招牌/})
db.shops.remove({name:/鸭颈王/})
db.shops.remove({name:/有限公司/})
db.shops.remove({name:/茶叶店$/})
db.shops.remove({name:/建材$/})
db.shops.remove({name:/贸易公司/})
db.shops.remove({name:/成人用品/})
db.shops.remove({name:/总代理/})
db.shops.remove({name:/家政/})

db.shops.remove({name:/分公司/})
db.shops.remove({name:/干洗店/})
db.shops.remove({name:/水洗店/})
db.shops.remove({name:/信息咨询/})
db.shops.remove({name:/支行/})
db.shops.remove({name:/营业部/})
db.shops.remove({name:/修鞋/})
db.shops.remove({name:/旅行社/})
db.shops.remove({name:/直销点/})
db.shops.remove({name:"商住"})
db.shops.remove({name:/盲人按摩/})
db.shops.remove({name:/服务机构/})
db.shops.remove({type:/^交通设施;桥/})
db.shops.remove({name:/收购店/})
db.shops.remove({name:/加油站/})
db.shops.remove({name:/加气站/})

db.shops.remove({name:/皮具护理/})
db.shops.remove({name:/公交车/})
db.shops.remove({name:/建筑装饰/})

db.shops.remove({name:/出国/,type:/^金融/})
db.shops.remove({name:/出国/,type:/^教育/})
db.shops.remove({name:/销售部/})
db.shops.remove({name:/有限责任公司/})

db.shops.remove({name:"流通处"})
db.shops.remove({name:"游客中心"})
db.shops.remove({t:11,name:/[0-9]+室$/})
db.shops.remove({t:10,name:/[0-9一-九]+期$/})
db.shops.remove({t:11,name:/[0-9一-九]+期$/})
db.shops.remove({name:"小吃部"})
db.shops.remove({name:"小区"})
db.shops.remove({name:/办事处$/})
db.shops.remove({name:/管理咨询机构$/})
db.shops.remove({name:/连锁机构$/})
db.shops.remove({name:/策划机构$/})
db.shops.remove({name:/酒店-/})
db.shops.remove({name:/大厦-/})
db.shops.remove({name:/网$/})

db.shops.find({name:/[^\-]{5,}-/})


db.shops.update({type:/^生活服务;便利店/},{$set:{d:50},$unset:{del:1}},false,true)
db.shops.update({type:/^金融/},{$set:{d:50},$unset:{del:1}},false,true)
db.shops.update({name:/拉面/},{$set:{d:50}},false,true)
db.shops.update({name:/牛肉面/},{$set:{d:50}},false,true)
db.shops.update({name:/鞋吧/},{$set:{d:50}},false,true)

db.shops.update({type:/^医疗/},{$set:{d:30}},false,true)
db.shops.update({type:/^教育;科研机构/},{$set:{d:30},$unset:{t:1}},false,true)
db.shops.update({name:/汽车/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/珠宝/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/首饰/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/摄影器材/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/摩托/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/美甲/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/工作坊/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/公司/},{$set:{d:30}},false,true)
db.shops.update({type:/^生活服务;摄影冲印/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/卫生服务站$/},{$set:{del:1},$unset:{d:1}},false,true)
db.shops.update({name:/精子/},{$set:{del:1},$unset:{t:1}},false,true)
db.shops.update({name:/生殖/},{$set:{del:1},$unset:{t:1}},false,true)


db.shops.update({name:/宿舍$/},{$set:{d:20}},false,true)

db.shops.update({name:/活动中心$/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/棋牌/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/文化室$/},{$set:{d:30},$unset:{t:1}},false,true)

db.shops.update({name:/包子/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/熟食/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/快餐/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/盖浇饭/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/大排档/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/米粉/},{$set:{d:40},$unset:{t:1}},false,true)
db.shops.update({name:/卤味/},{$set:{d:40},$unset:{t:1}},false,true)
db.shops.update({name:/鸭脖子/},{$set:{d:50},$unset:{t:1}},false,true)
db.shops.update({name:/饮食店$/},{$set:{d:30},$unset:{t:1}},false,true)
db.shops.update({name:/米线$/},{$set:{d:20}},false,true)

db.shops.update({name:/会所$/},{$set:{d:30},$unset:{t:1}},false,true)

db.shops.update({t:{$exists:false},name:/文体中心$/},{$set:{t:7}},false,true)
db.shops.update({t:{$exists:false},name:/体育中心$/},{$set:{t:7}},false,true)

db.shops.update({type:/^医疗/},{$set:{d:30},$unset:{t:1}},false,true)
db.shops.update({type:/^医疗;综合医院/, name:/医院$/},{$set:{t:14},$unset:{d:1}},false,true)
db.shops.update({type:/^医疗;专科医院/, name:/医院$/},{$set:{t:14},$unset:{d:1}},false,true)

db.shops.update({name:/招待所/},{$set:{d:30},$unset:{t:1}},false,true)


db.shops.update({t:13},{$unset:{d:1}},false,true)
