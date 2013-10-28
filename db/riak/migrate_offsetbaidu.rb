#https://github.com/basho/riak-ruby-client
#ripple

client = Ripple.client
bucket = client.bucket('boffsets')
Mongoid.session(:dooo)[:offsetbaidus].where({v:{"$exists" => false}}).each do |x|
  k = "%.2f%.2f" %  x["loc"]
  v = x["d"].map{|d| d.round(5)}
  obj = bucket.get_or_new(k)
  if obj.data.nil?
    obj.data=v
    obj.store
  end
  Mongoid.session(:dooo)[:offsetbaidus].find({_id:x["_id"]}).update({"$set" => {v:true}})
  #sleep 0.01
end
