use dface
db.mapabc2.find({city:"0571"}).forEach(function(x){
db.mapabc2.find({loc : { $near : x.loc , $maxDistance : 0.05 },name:x.name}).forEach(function(xx){printjson(xx);})
})