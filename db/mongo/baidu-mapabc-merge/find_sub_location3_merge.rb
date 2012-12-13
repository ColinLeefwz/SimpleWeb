SinaUser.collection.database.session[:tmp6].find.each do |x|
  begin
    shop = Shop.find(x["_id"].to_i)
  rescue Exception => e
    SinaUser.collection.database.session[:tmp7].insert(x)
  end
end

#//db.tmp7.find().forEach(function(x){ db.tmp6.remove({_id:x._id}) })

SinaUser.collection.database.session[:tmp6].find.each do |x|
  begin
    #shop = Shop.find(x["_id"].to_i)
    #shop.lo = x["lo"]
    #shop.save
    #上下两种mongoid的方式均不能更新lo，很奇怪。比如使用mongodb的语法
    #shop.update_attribute(:lo, x["lo"])
    Shop.collection.find({_id:x["_id"].to_i}).update("$set" => {lo:x["lo"]})
  rescue Exception => e
    puts e
  end
end


SinaUser.collection.database.session[:tmp6].find.each do |x|
  begin
    x["subs"].each {|y| Shop.find(y["_id"].to_i).update_attribute(:del2,true) }
  rescue Exception => e
    puts e
  end
end

