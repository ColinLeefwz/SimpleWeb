require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("baidu")
count=0
File.open("baidu-utf8.csv").each_line do |line|
      ss = line.split(",")
      ss=ss.map{|x| x.delete("\"")}
      ss[-1] = ss[-1].delete("\r\n")
      name=ss[0]
      lob=[ss[-1].to_f,ss[-2].to_f]
      if ss[-3] && ss[-3].length>0
        phone = ss[-3]
      else
        phone=ss[-4]
      end
      addr=ss[-5]
      type=ss[1..-6].inject("") {|mem,x| mem << x.to_s}
  coll.insert({_id:count,name: name,lob: lob,phone: phone,addr: addr,type: type})
  count+=1
end


