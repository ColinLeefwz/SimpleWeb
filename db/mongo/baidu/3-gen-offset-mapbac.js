db.loadServerScripts();
var count=10730484+1;
db.mapabc.find().skip(10730484).forEach(function(x){
//print(x._id);
x.lo = gcj02_to_real(x.loc);
x._id = count;
db.map2.insert(x);
count+=1;
})
