

var e = new RegExp("[（|）]+");

db.shops.find({name:e}).forEach(function(x){
  //print(x.name);
  name2=x.name.replace(/（/g,"(");
  name2=name2.replace(/）/g,")");
  //print(name2);
  db.shops.update({_id:x._id},{$set:{name:name2}});
})
