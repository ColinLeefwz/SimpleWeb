# coding: utf-8
class ShopPartner
  include Mongoid::Document
  field :_id, type: Integer #旅行社id或楼宇id或其它id
  field :partners, type: Array #合作商家的id [[合作商家,添加时间]]

  def self.find_or_new(id)
    shop_partner = self.find_by_id(id)
    if shop_partner.nil?
      shop_partner = self.new
      shop_partner._id = id
      shop_partner.partners = []
    end
    shop_partner
  end
end
