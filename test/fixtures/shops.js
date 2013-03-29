db.shops.remove();
db.shops.insert({ 
    "_id" : 1,
    "name" : "测试1",
    "city" : "0571",
    'loc': [39.896445, 116.317378],
    'shops': [2]
})

db.shops.insert({
    "_id" : 111,
    "name" : "测试1分店",
    "city" : "0571",
    'loc': [39.896445, 116.317378],
    'psid': 1
})

db.shops.insert({
    "_id" : 112,
    "name" : "测试1分店2",
    "city" : "0571",
    'loc': [39.896445, 116.317378],
    'psid': 1
})


db.shops.insert({
    "_id" : 2,
    "password" : '123456',
    "name" : "测试2",
    'loc': [[39.896445, 30.2359], 116.317378],
    "city" : "0571"
})

db.shops.insert({ 
    "_id" : 3,
    "password" : '123456',
    "name" : "测试3",
    "city" : "0571"
})

db.shops.insert({ 
    "_id" : 4,
    "password" : '123456',
    "name" : "测试4",
    "city" : "0571"
})

db.shops.insert({ 
    "_id" : 4928288,
    "addr" : "古翠路80",
    "city" : "0571",
    "lo" : [ [ 30.282535, 120.117039 ], [ 30.282558, 120.116757 ] ],
    "loc" : [ [ 30.280254, 120.121824 ], [ 30.280277, 120.121542 ] ],
    "name" : "浙江科技产业大厦",
    "password" : "123456",
    "shops" : [1,2],
    "t" : 6,
    "tel" : "",
    "type" : "商务住宅;楼宇;商务写字楼",
    "uftotal" : 5,
    "utotal" : 25
})

