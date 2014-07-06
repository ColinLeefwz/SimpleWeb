# coding: utf-8
class ShopLinePartner
  include Mongoid::Document
  field :_id, type: Moped::BSON::ObjectId   #路线id
  field :partners, type:Hash #景点的合作商家 {景点id => [合作商家1，合作商家2,...]}


  def self.find_or_new(id)
    slp= self.find_by_id(id)
    if slp.nil?
      slp = self.new
      slp._id = id
      slp.partners = {}
    end
    slp
  end
end
