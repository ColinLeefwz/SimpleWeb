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
  
  def mshop
    if mshop_id
      Mshop.find_by_id(mshop_id)
    else
      nil
    end
  end
  
end
