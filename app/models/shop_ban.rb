# coding: utf-8
class ShopBan
  include Mongoid::Document

  field :_id, type: Integer
  field :users, type:Array #用户id字符串

  def shop
    Shop.find_by_id(self._id)
  end

  def self.find2(sid)
    begin
      self.find(sid)
    rescue
      nil
    end
  end

end
