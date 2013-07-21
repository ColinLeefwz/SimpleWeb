# coding: utf-8

class UserFollow
  include Mongoid::Document
  field :follows, type:Array #关注
  
  def self.find_or_new(uid, fid)
    fid = Moped::BSON::ObjectId(fid) if fid.class==String
    begin
      uf = UserFollow.find(uid)
      uf.add_to_set(:follows, fid)
      uf.del_my_cache
    rescue
      uf = UserFollow.new
      uf.id = uid
      uf.follows = [fid]
      uf.save!
    end
    uf
  end
  
  def self.add(uid,fid)
    UserFollow.find_or_new(uid, fid) if Rails.env != "production" #发布时在FollowNotice里异步执行
    add_follows_redis(uid,fid) #follows数组在mongodb和redis同时保存，双写
    fuser = User.find_by_id(fid)
    if fuser && fuser.friend?(uid)
      add_good_friend_redis(uid,fid)
    end
    add_fans_redis(uid,fid) #fans和good_friend数组只保存在redis中
  end
  
  def self.del(uid,fid)
    uf = UserFollow.find(uid)
    uf.pull(:follows,fid)
    uf.del_my_cache
    Rails.cache.delete("UI#{fid}#{uid}")
    del_follows_redis(uid,fid)
    fuser = User.find_by_id(fid)
    if fuser && fuser.friend?(uid)
      del_good_friend_redis(uid,fid)
    end
    del_fans_redis(uid,fid)
  end
  
  
  def self.init_good_friend_redis
    UserFollow.all.each do |uf|
      users = uf.follows.map {|x| User.find_by_id(x) }
      users.delete(nil)
      users.delete_if {|x| !x.friend?(uf.id)}
      users.each_with_index{|u,idx| $redis.zadd("Frd#{uf.id}",idx,u.id)}
    end
  end
  
  def self.add_good_friend_redis(uid1,uid2)
    u1 = $redis.zcard("Frd#{uid1}") || 0
    $redis.zadd("Frd#{uid1}",u1,uid2)
    u2 = $redis.zcard("Frd#{uid2}") || 0
    $redis.zadd("Frd#{uid2}",u2,uid1)    
  end

  def self.del_good_friend_redis(uid1,uid2)
    $redis.zrem("Frd#{uid1}",uid2)
    $redis.zrem("Frd#{uid2}",uid1)    
  end
  
  def self.init_fans_redis
    User.where({auto:{"$ne" => true}}).each do |user|
      next if $redis.zcard("Fan#{user.id}") > 0
      arr = UserFollow.only(:_id).where({follows: user.id}).to_a
      next if arr.size==0
      arr.each_with_index{|uf,idx| $redis.zadd("Fan#{user.id}",idx,uf.id)}
    end
  end
  
  def self.add_fans_redis(uid,fid)
    u1 = $redis.zcard("Fan#{fid}") || 0
    $redis.zadd("Fan#{fid}",u1,uid)
  end
  
  def self.del_fans_redis(uid,fid)
    $redis.zrem("Fan#{fid}",uid)
  end 
  
  def self.add_follows_redis(uid,fid)
    u1 = $redis.zcard("Fol#{uid}") || 0
    $redis.zadd("Fol#{uid}",u1,fid)
  end
  
  def self.del_follows_redis(uid,fid)
    $redis.zrem("Fol#{uid}",fid)
  end 
  
  def self.init_follows_redis
    UserFollow.all.each do |uf|
      next unless uf.follows.size>0
      uf.follows.each_with_index{|uid,idx| $redis.zadd("Fol#{uf.id}",idx,uid)}
    end
  end
  

    
end