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
  
  def self.time_desc(time_i)
    diff = Time.now.to_i - time_i
    User.time_desc(diff)
  end
  
  def user
    User.find(self.uid)
  end
  
  def shop
    Shop.find_by_id(self.sid)
  end
  
  def add_to_redis
    return if user.invisible==2
    if( $redis.zadd("ckin#{self.sid}",Time.now.to_i, self.uid) )
      CheckinShopStat.add_one_redis(sid, user.gender)
    end
  end

  def self.clear_yesterday_redis
    now = Time.now
    yesterday = now.to_i-now.hour*3600-now.min*60-now.sec
    $redis.keys("ckin*").each do |key|
      $redis.zremrangebyscore(key, 0, yesterday)
    end
  end

  def self.get_users_redis(sid)
    $redis.zrevrange("ckin#{sid}",0,-1, withscores:true)
  end

end
