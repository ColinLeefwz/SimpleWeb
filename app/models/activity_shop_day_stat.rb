class ActivityShopDayStat
  include Mongoid::Document
 #从7-18日起每天活动商家首次签到的数据统计

  field :id, type:String
  field :mansion1, type:Hash #合作框架广告推送楼宇地点
  field :mansion2, type:Hash  #重点推送楼宇地点
  field :cooperation_shops, type:Hash #合作商家
  field :m1num, type:Integer #合作框架广告推送楼宇地点总数
  field :m2num, type:Integer #重点推送楼宇地点总数
  field :csnum, type:Integer #合作商家总数

end