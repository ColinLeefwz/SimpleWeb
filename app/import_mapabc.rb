require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("mapabc")

def to_hash(ss)
 {city: ss[0],name: ss[1],addr: ss[2],tel: ss[3],type: ss[4],loc: [ss[6].to_f,ss[5].to_f] }
end

def remove_yinhao(ss)
	ss.map {|x| x[1..-2]}
end


File.open("mapabc.csv").each_line do |x| 
 arr = remove_yinhao(x.split(","))
 coll.insert( to_hash(arr) )
end

#db.mapabc.ensureIndex( { loc : "2d" } )
