var num=0;
db.mapabc2.find().sort({name:1}).forEach(function(x){
try{
  num +=1;
  var flag=false;
  var reg = new RegExp("^" + x.name + "\\\(" );
  db.mapabc2.find({loc : { $near : x.loc , $maxDistance : 0.15 },name:reg}).forEach(function(xx){
    print(xx._id);
    flag=true;
  });
  if(flag){
	print(x._id);
	print(".\n");
  }	
  print(":"+num);
}catch(e){
	print(e);
}	

})