require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("dianping")
Mshop.all.each {|x| coll.insert({:id => x.id, :name => x.name, :loc => [x.lat.to_f,x.lng.to_f],:phone => x.phone, :city => x.mcity_id, :cc => x.comment_count, :man => x.manual, addr:x.address }) unless x.lng==0}.count
#db.shop.find().sort({"loc":-1}).limit(1)
coll.find.sort([:loc, :desc]).limit(1).to_a
coll.remove("id" => 46522)
#db.shop.ensureIndex( { loc : "2d" } )
coll.create_index([["loc", Mongo::GEO2D]])
#db.shop.find( { loc : { $near : [120.1077881,30.2796745] } } )
coll.find({"loc" => {"$near" => [30.2774137776093,120.112508787866]}}, {:limit => 20}).each do |p|
  puts p.inspect
end


