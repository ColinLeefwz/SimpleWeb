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

end

