require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("offsetbaidus")

id = 1

File.open("offset.csv").each_line do |x| 
  arr = x.split(",")
  loc=arr[2,3].map{|i| i[1..-2].to_f}
  hash = { _id:id, loc: [arr[1].to_f,arr[0].to_f], d:[loc[1],loc[0]]}
  coll.insert(hash)
  id+=1
end

