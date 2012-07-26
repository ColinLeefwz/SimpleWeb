db.mapabc2.find({city:"0571"}).forEach(function(x){
var reg = new RegExp("^"+x.name+".+");
db.mapabc2.find({loc : { $near : x.loc , $maxDistance : 0.05 },name:reg}).forEach(function(xx){printjson(xx);})
})