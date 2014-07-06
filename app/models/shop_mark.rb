# coding: utf-8
class ShopMark
  include Mongoid::Document
  field :sid, type: Integer   #被评价商家
  field :uid, type: Moped::BSON::ObjectId #评价用户
  field :gid, type: Moped::BSON::ObjectId #旅行团
  field :admin_sid, type: Integer #所属旅行社
  field :mark, type: Integer #评价得分
  field :com #评语

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :to => :user
    option.delegate :name, :to => :shop
    option.delegate :name, :to => :group
  end

  def shop
    Shop.find_by_id(sid)
  end

  def user
    User.find_by_id(uid)
  end

  def group
    Group.find_by_id(gid)
  end

end
