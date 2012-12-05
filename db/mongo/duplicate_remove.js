print(db.shops.count());

db.shops.find().forEach(function(x){
  db.shops.remove({loc : { $near : x.loc , $maxDistance : 0.001 },name:x.name, _id:{$ne : x._id}});
});

print(db.shops.count());
