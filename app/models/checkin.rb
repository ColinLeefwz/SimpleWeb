class Checkin
  include Mongoid::Document
  field :shop_id, type: Integer
  field :user_id
  field :gender, type:Integer
  field :loc, type:Array
  field :ip
  field :shop_name
  field :accuracy, type:Float
  field :od, type: Integer
  
  def cat
    self._id.generation_time
  end
  
  def time_desc
    diff = Time.now.to_i - self.cat.to_i
    User.time_desc(diff)
  end
  
  def self.time_desc(time)
    diff = Time.now.to_i - time.to_i
    User.time_desc(diff)
  end
  
  def user
    User.find(self.user_id)
  end
  
  def shop
    Shop.find(self.shop_id)
  end
  
end
