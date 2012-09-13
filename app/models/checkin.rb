class Checkin
  include Mongoid::Document
  field :sid, type: Integer
  field :uid, type: Moped::BSON::ObjectId
  field :sex, type:Integer
  field :loc, type:Array
  field :ip
  field :acc, type:Float
  field :od, type: Integer
  
  def cat
#    self._id.generation_time
    Time.at self._id.to_s[0,8].to_i(16)
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
    User.find(self.uid)
  end
  
  def shop
    Shop.find(self.sid)
  end
  
end
