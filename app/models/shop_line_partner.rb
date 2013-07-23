# coding: utf-8
class ShopLinePartner
  field :_id, type: Moped::BSON::ObjectId   #路线id
  field :partners, type:Array #景点的合作商家 [{景点id => [合作商家1，合作商家2,...]}]
end
