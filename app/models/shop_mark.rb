# coding: utf-8
class ShopMark
  include Mongoid::Document
  field :sid, type: Integer   #被评价商家
  field :uid, type: Moped::BSON::ObjectId #评价用户
  field :gid, type: Moped::BSON::ObjectId #旅行团
  field :mark, type: Integer #评价得分
  field :com #评语
  field :com_at,type: DateTime #评价时间

end
