# coding: utf-8
#游戏积分

class Game
  include Mongoid::Document
  field :gid, type: Integer #游戏编号
  field :sid, type: Integer #商家
  field :uid, type: Moped::BSON::ObjectId #用户
  field :score, type: Integer #游戏分数
  field :sn #兑奖SN码
  field :phone #中奖者手机号

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :to => :user
    option.delegate :name, :to => :shop
  end

  scope :eq_sid, ->(sid){where(sid: sid)}
  
  index({sid: 1, gid:1, socre:1})

  def shop
    Shop.find_by_id(self.sid)
  end
  
  def user
    User.find_by_id(self.uid)
  end
  
  def save_redis
    return false if ENV["RAILS_ENV"] != "production"
    self.add_redis
    self.save

  end
  
  def self.init_redis
    Game.all.each do |g|
      g.add_redis
    end
  end
  
  def redis_key
    "GAME#{self.gid}-#{self.sid}"
  end
  
  def add_redis
    if Game.where({sid:self.sid,uid:self.uid}).size > 0 
      $redis.zadd(redis_key,score,self.uid) if score > Game.where({sid:self.sid,uid:self.uid}).all.map{|m| m.score}.max
    else
      $redis.zadd(redis_key,score,self.uid)
    end
  end
   
end
