class Checkin
  include Mongoid::Document
  field :shop_id, type: Integer
  field :user_id, type: Integer
  field :loc, type:Array
  field :ip
  field :shop_name
  field :cat, type:DateTime
  field :accuracy, type:Float
  field :od, type: Integer
  
end
