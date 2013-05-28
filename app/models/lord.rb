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
  end
  
  def self.assign(sid,uid, creator=false)
    shop = Shop.find_by_id(sid)
    lord = Lord.find_by_id(sid)
    if lord
      return false if lord.uid==uid
      lord.change_dizhu(uid)
      Xmpp.send_chat($dduid, lord.oid, ": 您在#{shop.name}的地主👑被#{User.find_by_id(uid).name}抢走了")
    else
      lord = Lord.new
      lord.uid = uid
      lord.id = sid
      lord.uat = Time.now
      lord.save!
      if creator
        Xmpp.send_chat($dduid, uid,": 您创建的地点#{shop.name}审核通过,恭喜你成为地主👑")
      else
        Xmpp.send_chat($dduid,uid,": 恭喜你成为#{shop.name}的地主👑")
      end
    end
    return true
  end
  
  def self.init
    Shop.where({_id:{"$gt" => 21000000}, t: {"$ne" => nil}, creator: {"$ne" => nil}}).each do |s|
      Lord.assign(s.id, s.creator)
    end
  end
  
  
end
