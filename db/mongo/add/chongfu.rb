
db.shops.find({t:12}).sort({_id:1}).forEach(function(x){
  try{
    var reg = new RegExp("^"+x.name);
    var subs = [];
    lo = x.lo;
    if((typeof x.lo[0]) != "number") lo=x.lo[0];
    db.shops.find({lo:{$within:{$center:[lo,0.01]}}, name:reg, _id:{$ne:x._id}}).forEach(function(y){
      if(y.name==x.name){
        print("equal: "+x._id+":"+y._id);
        if(y._id < x._id) return;
        subs.push(y);
      } 
    })
    if(subs.length>0){
      //printjson(subs);
      x.subs = subs;
      db.chongfu.insert(x);
    }   
  }catch(e){
    print(e);
    print(x.name);
  }
})

Shop.collection.database.session[:chongfu].find().sort({_id:1}).each do |x|
  begin
	  shop = Shop.find(x["_id"])
    arr = shop.merge_locations(x["subs"])
    shop.update_attributes!({lo:arr})
  rescue Exception =>e
    puts x.to_yaml
    puts e
  end
end

db.chongfu.find().forEach(function(x){
  x.subs.forEach(function(y,i,a){ 
    db.shops.remove({_id:y._id})
  })
})

db.chongfu.find().forEach(function(x){
  x.subs.forEach(function(y,i,a){ 
    db.sub12s.remove({_id:y._id})
  })
})

