
db.shops.find({shops:{$exists:true}}).forEach(function(x){
  if((1+2*x.lo.length)<x.shops.length) print(x._id+"\t"+x.name+"\t"+x.lo.length+":"+x.shops.length);
})

Shop.where({shops:{"$exists" => true}}).each do |x|
  begin
    if x.lo.length < x.shops.length
      x.merge_subshops_locations
    end
  rescue Exception =>e
    puts x.to_yaml
    puts e
  end
end

Shop.where({shops:{"$exists" => true}}).each do |x|
  begin
    if (1+2*x.lo.length) < x.shops.length
      arr = x.merge_locations(x.sub_shops)
      Shop.collection.find({_id:x.id.to_i}).update("$set" => {lo:arr})
    end
  rescue Exception =>e
    puts x.to_yaml
    puts e
  end
end

#
