class ShopNotice
  include Mongoid::Document
  
  field :shop_id, type: Moped::BSON::ObjectId
  field :title
  field :begin, type:DateTime
  field :end, type:DateTime
  field :ord, type:Float
  
end
