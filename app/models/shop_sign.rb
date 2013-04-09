# encoding: utf-8
#签约商家合同

class ShopSign
  include Mongoid::Document
  field :htid #合同编号
  field :name #商家名称
  field :sid, type:Integer #对应的脸脸商家id，如果有多家店，对应到主店
  field :attch #附件

  validates_presence_of :htid, :name, :password
  validates_uniqueness_of :htid, :sid


end
