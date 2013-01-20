class ShopSinaUser
  include Mongoid::Document
  field :_id, type: Integer
  field :users, type:Array  

end