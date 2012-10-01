require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("baidu")

coll.find().each do |x|
  if x["type"] && x["type"][0] == "[" && x["type"][-1] != "]"
    #puts x
    i = x["type"].rindex("]")
    hash = {type:x["type"][0..i-1], addr:x["type"][i+1..-1]}
    i#puts hash
    coll.update({"_id" => x["_id"]},{"$set" => hash} )
  end
end


