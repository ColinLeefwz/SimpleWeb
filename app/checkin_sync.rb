require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("checkins")
Checkin.all.each do |x|
  hash = x.attributes.slice("mshop_id","user_id","ip","shop_name")
  hash.merge!( { loc: [x.lat.to_f,x.lng.to_f]} )
  hash.merge!( { cat: x.created_at.utc, accuracy: x.accuracy.to_f} )
  puts hash
  coll.insert hash
end
coll.create_index([["loc", Mongo::GEO2D]])


