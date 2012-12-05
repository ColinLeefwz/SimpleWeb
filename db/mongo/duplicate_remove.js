print(db.shops.count());

db.shops.find({_id:{$lt:20347004}}).sort({_id:1}).forEach(function(x){
  db.shops.remove({loc : { $near : x.loc , $maxDistance : 0.001 },name:x.name, _id:{$ne : x._id}});
});

print(db.shops.count());
