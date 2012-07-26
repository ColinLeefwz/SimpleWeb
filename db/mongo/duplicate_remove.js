db.mapabc2.find().forEach(function(x){
  var flag=false;
  db.mapabc2.find({loc : { $near : x.loc , $maxDistance : 0.05 },name:x.name, _id:{$ne : x._id}}).forEach(function(xx){
    printjson(xx);
    flag=true;
  });
  if(flag) printjson(x);
})
