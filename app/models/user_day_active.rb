# coding: utf-8
#每日用户活跃度：男性平均头像数、男性平均关注数、女性平均头像数、女性平均关注数

class UserDayActive
  include Mongoid::Document
  field :_id, type:String 
  field :mulogo, type:Float #每日男性平均头像数
  field :mufollow, type:Float #每日男性平均关注数
  field :fulogo, type:Float #每日女性平均头像数
  field :fufollow, type:Float #每日女性平均关注数

end

