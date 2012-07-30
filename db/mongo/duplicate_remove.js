print(db.mapabc2.count());

db.mapabc2.find().forEach(function(x){
  db.mapabc2.remove({loc : { $near : x.loc , $maxDistance : 0.05 },name:x.name, _id:{$ne : x._id}});
});

print(db.mapabc2.count());
