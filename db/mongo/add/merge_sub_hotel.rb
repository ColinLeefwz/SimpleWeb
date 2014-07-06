
db.shops.find({t:5,_id:{$gt:1724968}}).sort({_id:1}).forEach(function(x){
  try{
    var reg = new RegExp("^"+x.name);
    var subs = [];
    lo = x.lo;
    if((typeof x.lo[0]) != "number") lo=x.lo[0];
    db.shops.find({lo:{$within:{$center:[lo,0.01]}}, name:reg, _id:{$ne:x._id}}).forEach(function(y){
      subs.push(y);
    })
    if(subs.length>0){
      //printjson(subs);
      x.subs = subs;
      db.hotel_subs.insert(x);
    }   
  }catch(e){
    print(e);
    print(x.name);
  }
})


db.hotel_subs.find().forEach(function(x){
	x.subs.forEach(function(y,i,a) { db.shops.remove({_id:y._id}) });
})


Shop.collection.database.session[:hotel_subs].find().sort({_id:1}).each do |x|
  begin
	  shop = Shop.find(x["_id"])
    arr = shop.merge_locations(x["subs"])
    shop.update_attributes!({lo:arr})
  rescue Exception =>e
    puts x.to_yaml
    puts e
  end
end


#重复的数据会错误的两个都被删除，所以要找回来。
Shop.collection.database.session[:hotel_subs].find().sort({_id:1}).each do |x|
  begin
	  shop = Shop.find_by_id(x["_id"])
    if shop.nil?
      puts "#{x['_id']}\t#{x['name']}"
      x.delete("subs")
      Shop.collection.insert(x);
    end
  rescue Exception =>e
    puts x.to_yaml
    puts e
  end
end

count=1
shop=nil
File.open("tmp2.txt").each_line do |x|
  ss = x.split("\t")
  id = ss[0].to_i
  if count%2==0
    arr = shop.merge_locations([Shop.find(id)])
    shop.update_attributes!({lo:arr})
  else
    shop = Shop.find(id)
  end
  count+=1
end
