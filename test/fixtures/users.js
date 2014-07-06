db.users.remove();
db.users.insert({
    "_id" : ObjectId("502e6303421aa918ba00007c"),
    "birthday" : "",
    "gender" : 1,
    "hobby" : "",
    "invisible" : 0,
    "jobtype" : null,
    "name" : "袁乐天",
    "oid" : 154,
    "password" : "c84dad462d5b7282",
    "signature" : "",
    "wb_uid" : "a1"
})

db.users.insert({
    "_id" : ObjectId("502e6303421aa918ba000002"),
    "birthday" : "",
    "gender" : 0,
    "hobby" : "",
    "invisible" : 0,
    "jobtype" : null,
    "name" : "25",
    "oid" : 24,
    "password" : "468f4c34c42170c5",
    "signature" : "",
    "wb_uid" : "1644166662",
    "blacks" : [{
        "id" : ObjectId("502e6303421aa918ba00007c"),
        "report" : false
    }]
})

db.users.insert({
    "_id" : ObjectId("502e6303421aa918ba000007"),
    "birthday" : null,
    "gender" : 1,
    "hobby" : null,
    "invisible" : 0,
    "jobtype" : null,
    "name" : "黄朝兴",
    "oid" : 37,
    "password" : "da9ed318086e601f",
    "signature" : null,
    "wb_uid" : "1934660880",

})

db.users.insert({
    "_id" : ObjectId("502e6303421aa918ba000005"),
    "gender" : 1,
    "hobby" : "",
    "invisible" : 0,
    "jobtype" : null,
    "name" : "袁乐天",
    "oid" : 154,
    "password" : "c84dad462d5b7282",
    "signature" : "",
    "wb_uid" : "a1"
})


db.users.insert({
	"_id" : ObjectId("502e6303421aa918ba000001"),
	"birthday" : "1997-7-2",
	"gender" : 1,
	"head_logo_id" : ObjectId("507b5ac0421aa9cf3200000b"),
	"hobby" : "Weiqi, go",
	"invisible" : 0,
	"job" : "",
	"jobtype" : 2,
	"multip" : true,
	"name" : "樱桃红了",
	"oid" : 1,
	"password" : "1",
	"pcount" : 7,
	"signature" : "热爱生活,做自己喜欢的事情！",
	"wb_uid" : "1884834632"
})
