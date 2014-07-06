# coding: utf-8
class ShopPartner
  include Mongoid::Document
  field :_id, type: Integer #旅行社id或楼宇id或其它id
  field :partners, type: Array #合作商家的id [['合作商家',添加时间]]
#  field :coupon_t, type: Integer  #1 => 发送合作商家签到优惠券， 2 => 发送合作商家的分享券， 3 => 合作的商家签到/分享券都发。 nil => 都不发送(旅行社是这种情况)
  


def shop
  Shop.find_by_id(id)
end

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

