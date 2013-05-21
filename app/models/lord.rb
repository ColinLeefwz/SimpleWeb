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
  
  def self.assign(sid,uid)
    lord = Lord.find_by_id(sid)
    if lord
      lord.change_dizhu(uid)
    else
      lord = Lord.new
      lord.uid = uid
      lord.id = sid
      lord.uat = Time.now
      lord.save!
    end
  end
  
  def self.init
    Shop.where({_id:{"$gt" => 21000000}, t: {"$ne" => nil}, creator: {"$ne" => nil}}).each do |s|
      Lord.assign(s.id, s.creator)
    end
  end
  
  
end
