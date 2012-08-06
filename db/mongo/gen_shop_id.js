var i=1;
db.shops.find().sort({city:1,name:1}).forEach(function(x){
  x._id=i;
  db.temp.insert(x);
  i+=1;
})

db.shops.renameCollections("mapabc2");
db.temp.renameCollection("shops");
db.shops.ensureIndex({loc:"2d"});
db.shops.ensureIndex({lo:"2d"});
db.shops.ensureIndex({t:1});
db.shops.ensureIndex({type:1});
db.shops.ensureIndex({city:1});
db.shops.ensureIndex({name:1});