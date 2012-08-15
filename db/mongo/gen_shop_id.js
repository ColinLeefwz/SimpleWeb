var i=1;
db.shops.find().sort({city:1,name:1}).forEach(function(x){
  x._id=i;
  db.temp.insert(x);
  i+=1;
})

db.shops.renameCollection("mapabc2");
db.temp.renameCollection("shops");
db.shops.ensureIndex({loc:"2d"},{background:true});
db.shops.ensureIndex({lo:"2d"},{background:true});
db.shops.ensureIndex({t:1},{background:true});
db.shops.ensureIndex({type:1},{background:true});
db.shops.ensureIndex({city:1},{background:true});
db.shops.ensureIndex({name:1},{background:true});
