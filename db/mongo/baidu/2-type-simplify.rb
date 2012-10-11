require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("baidu")
tmp2 = db.collection("tmp22")

coll.find({type:/^\[\[/}).each do |x|
begin
  #puts x
  next unless x["type"] && x["type"][0] == "["
  type = x["type"].gsub("[","").gsub!("]",";").gsub!(/(;)+$/,"")
  type = type.split(";").map{|x| x.gsub(/^(\d)+/,"")}.inject(""){|mem,x| mem << ";"+x.to_s}
  #puts type[1..-1]
  coll.update({_id:x["_id"]},{"$set" => {type:type[1..-1]}})
rescue  Exception => error
  tmp2.insert(x)
end
end


