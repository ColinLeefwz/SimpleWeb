require 'mongo'
conn = Mongo::Connection.new("192.168.1.22")
conn.database_names
db = conn.db("dface")
coll = db.collection("users")


User.all.each do |u|
  hash = u.attributes.slice("wb_uid","name","gender","birthday","password",
  "invisible","signature","job ","jobtype","hobby").as_json
  hash.merge!(oid:u.id)
  coll.insert hash
end

Follow.all.each do |f|
  coll.update({id:f.user_id},{ "$push" => { follows: f.follow_id } })
end

Blacklist.all.each do |b|
  coll.update({id:b.user_id},{ "$push" => { blacks: b.block_id } })
end



coll = db.collection("user_logos")
UserLogo.all.each do |x|
  hash = x.attributes.slice("user_id","avatar_file_name","avatar_content_type","avatar_file_size","avatar_updated_at","ord").as_json
  hash.merge!(_id:x.id)
  coll.insert hash  
end

# 切换为mongoid

# db.users.update({},{ $rename : { "id":"oid" } },false,true)
# db.users.update({},{ $unset : { "blacks" : 1} },false,true)


User.all.each do |u|
  next if u.follows.nil?
  fs = u.follows.map {|x| User.where({oid:x}).first._id if x.class==Fixnum}
  u.update_attributes(follows:fs)
end
  
