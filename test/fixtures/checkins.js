db.checkins.remove();
db.checkins.insert({ 
    "_id" : ObjectId("50598b371d41c8c11a000001"),
    "uid" : ObjectId("502e6303421aa918ba00007c"),
    "ip" : "192.168.1.1",
    "sid" : 2,
    'od' :1
})



db.checkins.insert({ 
    "_id" : ObjectId("50598b371d41c8c11a000002"),
    "uid" : ObjectId("502e6303421aa918ba00007c"),
    "ip" : "192.168.1.2",
    "sid" : 1,
    'od' :2
})

db.checkins.insert({ 
    "_id" : ObjectId("50598b371d41c8c11a000003"),
    "uid" : ObjectId("502e6303421aa918ba000002"),
    "ip" : "192.168.1.3",
    "sid" : 2,
    'od' :2
})

db.checkins.insert({ 
    "_id" : ObjectId("50588b371d41c8c11a000004"),
    "uid" : ObjectId("502e6303421aa918ba000002"),
    "ip" : "192.168.1.4",
    "sid" : 1,
    'od' :2
})

db.checkins.insert({
    "_id" : ObjectId("50598b371d41c8c11a000004"),
    "uid" : ObjectId("502e6303421aa918ba000002"),
    "ip" : "192.168.1.4",
    "sid" : 1,
    'od' :2
})

db.checkins.insert({
    "_id" : ObjectId("50598b371d41c8c11a000011"),
    "uid" : ObjectId("502e6303421aa918ba000005"),
    "ip" : "192.168.1.1",
    "sid" : 2,
    'od' :1
})