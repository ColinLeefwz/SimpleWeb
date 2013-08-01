class ShopReport
  include Mongoid::Document

  field :sid, type: Integer
  field :uid, type: Moped::BSON::ObjectId
  field :des
  field :flag,type: Integer
  field :type  #报错类型

  
  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :to => :user
    option.delegate :name, :to => :shop
  end


  def shop
    @shop ||= Shop.find_by_id(self.sid)
  end

  def user
    @user ||= User.find_by_id(self.uid)
  end

  
end
