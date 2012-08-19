class Checkin
  include Mongoid::Document
  field :shop_id, type: Integer
  field :user_id
  field :loc, type:Array
  field :ip
  field :shop_name
  field :accuracy, type:Float
  field :od, type: Integer
  
  def cat
    self._id.generation_time
  end
  
end
