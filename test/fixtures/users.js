db.users.remove();
db.users.insert({
    "_id" : ObjectId("502e6303421aa918ba00007c"),
    "birthday" : "",
    "follows" : [ ObjectId("502e6303421aa918ba000002") ],
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
    "follows" : [ 	ObjectId("502e6303421aa918ba00007c"), 	ObjectId("502e6303421aa918ba000007") ],
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
    "blacks" : [{
        "id" : ObjectId("502e6303421aa918ba00007c"),
        "report" : false
    }, {
        "id" : ObjectId("502e6303421aa918ba000002"),
        "report" : true
    } ]
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