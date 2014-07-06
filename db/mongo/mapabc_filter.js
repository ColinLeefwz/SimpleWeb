
db.mapabc.find({type: /^$/, city: "0571"},{_id: 0,addr:0, tel:0})              

db.mapabc.find({type: /行政地名;村庄级地名$/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^餐饮服务/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^住宿服务/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^科教文化服务/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^商务住宅/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^体育休闲服务/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^汽车/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^风景名胜/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^道路附属设施;服务区/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^购物服务/}).forEach(function(obj){db.mapabc2.insert(obj);})

db.mapabc.find({type: /^医疗保健服务;综合医院/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^医疗保健服务;专科医院/}).forEach(function(obj){db.mapabc2.insert(obj);})

db.mapabc.find({type: /^生活服务;美容美发店/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^生活服务;电讯营业厅/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^生活服务;洗浴推拿场所/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^生活服务;人才市场/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /^生活服务;电力营业厅/}).forEach(function(obj){db.mapabc2.insert(obj);})

db.mapabc.find({type: /火车站$/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /汽车站$/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /码头$/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /飞机场$/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /客运港$/}).forEach(function(obj){db.mapabc2.insert(obj);})
db.mapabc.find({type: /过境口岸$/}).forEach(function(obj){db.mapabc2.insert(obj);})

