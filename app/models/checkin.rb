class Checkin
  include Mongoid::Document
  field :sid, type: Integer #商家id
  field :uid, type: Moped::BSON::ObjectId #用户id
  field :sex, type:Integer #用户性别
  field :loc, type:Array  #经纬度
  field :ip   #ip地址
  field :acc, type:Float  #经纬度的精确度
  field :od, type: Integer  #用户选择的商家在现场列表中的位置
  field :del, type: Boolean #删除标记
  field :alt, type:Float    #海拔高度
  field :altacc, type: Integer  #海拔高度的精确度
  
  
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
