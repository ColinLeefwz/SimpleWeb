# coding: utf-8
class ShopBan
  include Mongoid::Document

  field :_id, type: Integer
  field :users, type:Array #用户id字符串

  delegate :name, :_id , :to => :shop, :allow_nil => true, :prefix => true
  
  after_find do |obj|
    obj._id = obj._id.to_i
  end

  def shop
    Shop.find_by_id(self._id)
  end

end
