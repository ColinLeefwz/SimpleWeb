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
  hash.merge!(oid:x.id)
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
  
class Blacklist < ActiveRecord::Base; end

Blacklist.all.each do |b|
  u = User.where({oid:b.user_id}).first
  bu = User.where({oid:b.block_id}).first
  u.add_to_set(:blacks, {id:bu._id,report:b.report})
end

UserLogo.all.each do |u|
  user = User.where({oid:u.user_id}).first
  puts user
  next if user.nil?
  u.update_attributes(user_id:user._id)
end

UserLogo.all.each do |u|
  u.update_attributes(ord:u.ord.to_f)
  u.update_attributes(avatar_updated_at:Time.now)
end

def dir_path(id)
  "./public/system/avatars/#{id}"
end

UserLogo.all.each do |u|
begin
  oldd = dir_path(u.oid)
  newd = dir_path(u._id)
  cmd = "mv #{oldd} #{newd}"
  puts cmd
rescue
end
end

Checkin.all.each do |x|
  u = User.where({oid:x.user_id}).first
  next if u.nil?
  puts u._id
  x.update_attribute(:user_id, u._id)
end


