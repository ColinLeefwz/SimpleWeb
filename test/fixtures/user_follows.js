db.user_follows.remove();
db.user_follows.insert({
    "_id" : ObjectId("502e6303421aa918ba00007c"),
    "follows" : [ ObjectId("502e6303421aa918ba000002") ]
})

db.user_follows.insert({
    "_id" : ObjectId("502e6303421aa918ba000002"),
    "follows" : [ 	ObjectId("502e6303421aa918ba00007c"), 	ObjectId("502e6303421aa918ba000007") ]
})

db.user_follows.insert({
    "_id" : ObjectId("502e6303421aa918ba000007"),
    "follows" : []
})

db.user_follows.insert({
    "_id" : ObjectId("502e6303421aa918ba000005"),
    "follows" : []

})


db.user_follows.insert({
	"_id" : ObjectId("502e6303421aa918ba000001"),
    "follows" : []
})
