
require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("mapabc2")

arr = []
count = 0

File.open("sublocation.txt").each_line do |x|
 if x[0]=="."
  #puts arr
  shop = coll.find_one({:_id => BSON::ObjectId(arr[-1])})
  #puts shop
  if shop["loc"][0].class==Array
      loc = shop["loc"]
  else
      loc = [shop["loc"]]
  end
  arr[0..-2].each do |i|
    loc <<  coll.find_one({:_id => BSON::ObjectId(i)})["loc"]
  end
  coll.update({:_id => BSON::ObjectId(arr[-1])},{'$set' => {loc: loc} })
  arr = []
  count += 1
  #break
 elsif x[0]=="#" || x.length<10
  next
 else
  arr << x
 end
end

puts count