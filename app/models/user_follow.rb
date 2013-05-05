# coding: utf-8

class UserFollow
  include Mongoid::Document
  field :follows, type:Array #关注
  
  def self.find_or_new(uid)
    begin
      uf = UserFollow.find(uid)
    rescue
      uf = UserFollow.new
      uf.id = uid
      uf.follows = []
      uf.save!
    end
    uf
  end
  
  def self.add(uid,fid)
    uf = UserFollow.find_or_new(uid)
    uf.add_to_set(:follows, fid)
    uf.del_my_cache
    Rails.cache.delete("UI#{fid}#{uid}")
    fuser = User.find_by_id(fid)
    if fuser && fuser.friend?(uid)
      add_good_friend_redis(uid,fid)
    end
  end
  
  def self.del(uid,fid)
    uf = UserFollow.find(uid)
    uf.pull(:follows,fid)
    uf.del_my_cache
    Rails.cache.delete("UI#{fid}#{uid}")
    fuser = User.find_by_id(fid)
    if fuser && fuser.friend?(uid)
      del_good_friend_redis(uid,fid)
    end
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

    
end