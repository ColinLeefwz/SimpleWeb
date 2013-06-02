# coding: utf-8
#地主

class Lord
  include Mongoid::Document
  field :_id, type: Integer #商家
  field :uid, type: Moped::BSON::ObjectId #当前地主
  field :uat, type: DateTime #当选地主时间
  field :oid, type: Moped::BSON::ObjectId #上任地主
  field :oat, type: DateTime #上任地主时间
  field :ids, type: Array #所有曾经的地主
  
  index({uid: 1})
  index({del: 1},{ sparse: true })
  
  def shop
    Shop.find_by_id(self.id)
  end
  
  def change_dizhu(uid, t=Time.now)
    if self.oid
      arr = self.ids
      arr = [] if arr.nil?
      self.ids = arr + [self.oid]
    end
    self.oid = self.uid
    self.oat = self.uat
    self.uid = uid
    self.uat = t
    self.save!
    self.add_lord_redis
    self.del_old_lord_redis
  end
  
  def allow_lord?(sid,uid,creator)
    return true if creator
    today_sid = Rails.cache.read("JOIN-LORD#{uid}")
    return true unless today_sid
    return true if today_sid==sid
    lord = Lord.find_by_id(sid)
    return true if lord && lord.oid==uid
    Resque.enqueue(XmppMsg, $dduid,uid,": 抱歉，一天只能抢一次地主!")
    return false
  end
  
  def self.assign(sid,uid, creator=false)
    return unless allow_lord?(sid,uid,creator)
    shop = Shop.find_by_id(sid)
    lord = Lord.find_by_id(sid)
    if lord
      return false if lord.uid==uid
      lord.change_dizhu(uid)
      Resque.enqueue(XmppMsg, uid, lord.oid, ": 您在#{shop.name}的地主👑被#{User.find_by_id(uid).name}抢走了")
      Resque.enqueue(XmppMsg, $dduid,uid,": 恭喜你成为#{shop.name}的地主👑")
    else
      lord = Lord.new
      lord.uid = uid
      lord.id = sid
      lord.uat = Time.now
      lord.save!
      lord.add_lord_redis
      if creator
        Resque.enqueue(XmppMsg, $dduid, uid,": 您创建的地点#{shop.name}审核通过,恭喜你成为地主👑")
        $redis.sadd("LORD2#{uid}", sid)
      else
        Resque.enqueue(XmppMsg, $dduid,uid,": 恭喜你成为#{shop.name}的地主👑")
      end
    end
    unless creator
      Rails.cache.write("JOIN-LORD#{uid}", sid, :expires_in => 6.hours)
    end
    return true
  end
  
  def self.init
    Shop.where({_id:{"$gt" => 21000000}, t: {"$ne" => nil}, creator: {"$ne" => nil}}).each do |s|
      Lord.assign(s.id, s.creator)
    end
  end
  
  def self.init_lord_redis
    Lord.all.each do |lord|
      lord.add_lord_redis
    end
  end
  
  def add_lord_redis
    key = "LORD#{self.uid}"
    u1 = $redis.zcard(key) || 0
    $redis.zadd(key,u1,self.id)
  end
  
  def del_old_lord_redis
    return if self.oid.nil?
    key = "LORD#{self.oid}"
    $redis.zrem(key, self.id)
  end
  
  
  
end
