# coding: utf-8

class ShopInfo
  include Mongoid::Document

  field :_id, type: Integer
  
  field :addr
  field :tel 
  field :phone
  #field :cc, type:Integer  #点评的评论数
  field :type              #从mapabc导入的商家类型
  field :mid, type:Integer
  field :osm_id, type:Integer
  field :contact

  after_find do |obj|
    obj._id = obj._id.to_i
  end

  def self.new2(info={})
    shop_info  = self.new(info)
    return shop_info unless shop_info.addr.blank?
    return shop_info unless shop_info.tel.blank?
    return nil
  end
end

