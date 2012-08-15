hash = {}

File.open("shop_type.txt").each_line do |x|
    v = x[0].to_i
    next if v==0
    key = x[1..-2]
    puts "#{v}: #{key}"
    hash[key] = v
end


require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("mapabc2")


coll.find().each do |x|
  num = hash[x["type"]]
  coll.update({"_id" => x["_id"]},{'$set' => {t: num} }) unless num.nil?
end

