db.shops.remove();
db.shops.insert({ 
    "_id" : 1,
    "name" : "测试1",
    "city" : "0571",
    'loc': [39.896445, 116.317378],
    'shops': [2],
    'password': '7c4a8d09ca3762af'
})

db.shops.insert({
    "_id" : 111,
    "name" : "测试1分店",
    "password": '7c4a8d09ca3762af',
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
    "password" : '7c4a8d09ca3762af',
    "name" : "测试2",
    'loc': [[39.896445, 30.2359], 116.317378],
    "city" : "0571"
})

db.shops.insert({ 
    "_id" : 3,
    "password" : '7c4a8d09ca3762af',
    "name" : "测试3",
    "city" : "0571"
})

db.shops.insert({ 
    "_id" : 4,
    "password" : '7c4a8d09ca3762af',
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
    "password" : "7c4a8d09ca3762af",
    "shops" : [1,2],
    "t" : 6,
    "tel" : "",
    "type" : "商务住宅;楼宇;商务写字楼",
    "uftotal" : 5,
    "utotal" : 25
})

db.shops.insert({ 
    "_id" : 6544448,
    "city" : "0571",
    "lo" : [ [ 30.2838366491909, 120.114861171554 ],
        [ 30.2838506825448, 120.11486521392901 ],
        [ 30.2841502162037, 120.117443620234 ],
        [ 30.2837623503445, 120.117419815138 ],
        [ 30.2837623503445, 120.117419815138 ],
        [ 30.283494, 120.116104 ] ],
    "name" : "西湖国际科技大厦",
    "password" : "7c4a8d09ca3762af",
    "password_confirmation" : "123456",
    "t" : 10,
    "utotal" : 2,
    "v" : 50
})

db.shops.insert({
    "_id" : 21830325,
    "city" : "0571",
    "creator" : ObjectId("50ea8be1c90d8bd530000020"),
    "i" : true,
    "name" : "脸脸商厦",
    "password" : "7c4a8d09ca3762af",
    "shops" : [
        21830327,
        21830326,
        21828775
    ],
    "t" : 0,
    "utotal" : 0
})



