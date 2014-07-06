# coding: utf-8
#黑名单

class UserBlack
  include Mongoid::Document
  
  field :uid, type: Moped::BSON::ObjectId #举报人
  field :bid, type: Moped::BSON::ObjectId  #被拉黑人
  field :report, type:Integer #1代表举报，需要脸脸的工作人员处理
  field :flag,type: Boolean ,default:false #代表是否已处理

  index({ uid: 1, bid: 1 })
  index({ report: 1, flag: 1 })


  def self.find_buser
    User.find_by_id(:bid)
  end
  
  def user
    User.find_by_id(self.uid)
  end

  def buser
    User.find_by_id(self.bid)
  end

  def self.init_black_redis
    UserBlack.all.each do |black|
      black.add_black_redis
    end
  end
  
  def add_black_redis
    key = "BLACK#{self.uid}"
    u1 = $redis.zcard(key) || 0
    $redis.zadd(key,u1,self.bid)
  end
  
  def self.del_black_redis(uid,bid)
    key = "BLACK#{uid}"
    $redis.zrem(key, bid)
  end
  
  

end
