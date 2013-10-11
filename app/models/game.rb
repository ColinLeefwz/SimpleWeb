# coding: utf-8
#游戏积分

class Game
  include Mongoid::Document
  field :gid, type: Integer #游戏编号
  field :sid, type: Integer #商家
  field :uid, type: Moped::BSON::ObjectId #用户
  field :score, type: Integer #游戏分数
  
  index({sid: 1, gid:1, socre:1})

  def shop
    Shop.find_by_id(self.sid)
  end
  
  def user
    User.find_by_id(self.uid)
  end
   
end
