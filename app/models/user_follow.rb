# coding: utf-8

class UserFollow
  include Mongoid::Document
  field :follows, type:Array #关注
  
  def self.find_or_new(uid, fid)
    fid = Moped::BSON::ObjectId(fid) if fid.class==String
    begin
      uf = UserFollow.find(uid)
      return if uf.follows.find{|x| x.to_s==fid.to_s}
      uf.add_to_set(:follows, fid)
      uf.del_my_cache
      return true
    rescue Mongoid::Errors::DocumentNotFound => e
      return first_add(uid, [fid])
    end
    uf
  end
  
  def self.find_or_news(uid,fids)
    fids.each do |fid| 
      #puts fid
      find_or_new(uid,fid)
    end
  end
  
  def self.first_add(uid,follows)
    uf = UserFollow.new
    uf.id = uid
    uf.follows = follows
    uf.save
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
  
  def self.check(in_place_fix=true)
    User.all.each do |user|
      check_user(user)
    end
  end
  
  def self.check_user(user, in_place_fix=true)
    fos = user.follow_ids.to_set
    fas = user.fan_ids.to_set
    fis = user.good_friend_ids.to_set
    uf = UserFollow.find_by_id(user.id)
    if uf.nil? 
      if fos.size==0
        return
      else
        if in_place_fix
          find_or_news(user.id, user.follow_ids)
        else
          puts "3#{user.name}"
          #hash = {_id:user.id,fos:fos.size, follows:0}
          #Shop.collection.database.session[:tmp3].insert(hash)
        end
      end
    end
    foas = fos.intersection(fas)
    if foas.size > fis.size
      if in_place_fix
        foas.each {|uid| add_good_friend_redis(user.id,uid)}
      else
        puts "1#{user.name}"
        #hash = {_id:user.id,fos:fos.size, fas:fas.size, fis:fis.size, foas:foas.size}
        #Shop.collection.database.session[:tmp1].insert(hash)
      end
    end
    if foas.size < fis.size
      if in_place_fix
        foas.each {|uid| add_fans_redis(user.id,uid)}
      else
        puts "4#{user.name}"
        #hash = {_id:user.id,fos:fos.size, fas:fas.size, fis:fis.size, foas:foas.size}
        #Shop.collection.database.session[:tmp1].insert(hash)
      end
    end      
    if uf && uf.follows && uf.follows.size != fos.size
      if in_place_fix
        find_or_news(user.id, user.follow_ids)
      else
        puts "2#{user.name}"
        #hash = {_id:user.id,fos:fos.size, follows:uf.follows.size}
        #Shop.collection.database.session[:tmp2].insert(hash)
      end
    end
  end
  
  

    
end
