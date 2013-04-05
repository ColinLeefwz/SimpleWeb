class ShopSinaUser
  include Mongoid::Document
  field :_id, type: Integer
  field :users, type:Array  
  
  after_find do |obj|
    obj._id = obj._id.to_i
  end

end