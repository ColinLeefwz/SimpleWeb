
require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("offsets")

id = 1

File.open("offset.csv").each_line do |x| 
  arr = x.split(",").map{|i| i[1..-2].to_f}
  hash = { _id:id, loc: [arr[1],arr[0]], d:[arr[3],arr[2]]}
  coll.insert(hash)
  id+=1
end

=begin   

db.shops.find().forEach(function(x){
  var str = "gcj02_to_real(["+x.loc+"])";
  var loc2 = db.eval(str);
  db.shops.update({_id:x._id},{$set:{lo:loc2}});
})
 
=end

