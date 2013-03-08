class ShopReport
  include Mongoid::Document

field :sid, type: Integer
field :uid, type: Moped::BSON::ObjectId
field :des
  
end
