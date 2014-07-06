print(db.shops.count());

db.shops.find({_id:{$lt:20347004}}).sort({_id:1}).forEach(function(x){
  db.shops.remove({lo : { $near : x.lo , $maxDistance : 0.001 },name:x.name, _id:{$ne : x._id}});
  db.shops.find({lo : { $near : x.lo , $maxDistance : 0.02 },name:x.name, _id:{$ne : x._id}}).forEach(function(y){
    db.tmp2.insert(x);
    db.tmp2.insert(y);
  })
});

print(db.shops.count());
