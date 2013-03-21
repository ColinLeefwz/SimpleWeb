class ShopReport
  include Mongoid::Document

  field :sid, type: Integer
  field :uid, type: Moped::BSON::ObjectId
  field :des
  field :flag,type: Integer

  def shop
    Shop.find_by_id(self.sid)
  end

  def user
    User.find_by_id(self.uid)
  end

  
end
