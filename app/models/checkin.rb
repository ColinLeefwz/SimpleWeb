# coding: utf-8

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
  field :bssid #wifi上网时的bssid
  field :city #city 城市
  
  field :photos, type:Array #本次签到期间发该商家的图片
  
  index({ uid: 1})
  index({ sid: 1})
  
  def time_desc
    diff = Time.now.to_i - self.cati
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
  
  #保存用户的签到到商家的当前签到redis集合中。
  #如果是新用户，更新商家用户总数的统计；如果不是，仅更新最后出现时间（也就是zset的score，zadd的效果）。
  def add_to_redis
    return false if user.invisible==2
    if( $redis.zadd("ckin#{self.sid.to_i}",Time.now.to_i, self.uid) )
      CheckinShopStat.add_one_redis(sid, user.gender)
      return true
    end
    return false
  end

  #清除昨天的商家签到记录，由cronjob调用
  def self.clear_yesterday_redis
    now = Time.now
    yesterday = now.to_i-now.hour*3600-now.min*60-now.sec
    $redis.keys("ckin*").each do |key|
      $redis.zremrangebyscore(key, 0, yesterday)
    end
  end

  #得到当天商家用户列表
  def self.get_users_redis(sid)
    $redis.zrevrange("ckin#{sid.to_i}",0,-1, withscores:true)
  end
  
  def self.get_users_count_redis(sid)
    $redis.zcard("ckin#{sid.to_i}")
  end
  
  #批量获得商家当天的用户总数
  def self.get_users_count_multi(sid_arr)
    code = <<LUA
    local count = function(x) return redis.pcall('zcard','ckin'..x) end
    local map = function(func, array)
       local new_array = {}
       for i,v in ipairs(array) do
         new_array[i] = func(v)
       end
       return new_array
    end
    return map(count,ARGV)
LUA
    $redis.eval(code, [], sid_arr)
    
  end
  
  def to_trace
    $weeks = ['周一','周二','周三','周四','周五','周六','周日']
    if cat > Date.today.to_datetime
      day = "今天" 
    elsif cat > Date.yesterday.to_datetime
      day = "昨天"
    elsif cat > Date.yesterday.prev_day.to_datetime
      day = "前天"
    elsif cat > Date.today.beginning_of_week
      day = $weeks[cat.days_to_week_start]
    elsif cat > Date.today.prev_week
      day = "上"+$weeks[cat.days_to_week_start]      
    elsif cat.year == Date.today.year
      day = cat.strftime("%m.%d")
    else
      day = cat.strftime("%2Y.%m.%d")
    end
    ps = []
    unless photos.nil?
      photos.each do |x| 
        begin
         p=Photo.find(x)
         ps << p.logo_thumb_hash.merge({id:p.id,desc:p.desc})
        rescue Exception => err 
          Rails.logger.error "\nInternal Server Error: #{err.class.name}, #{Time.now}"
          err.backtrace.each {|x| Rails.logger.error x}
        end
      end
    end
    shopname = shop.nil?? "" : shop.name
    {id: self._id, time: [day,cat.strftime("%H ：%M")], shop: shopname, shop_id:sid.to_i, photos:ps}
  end

  def self.merge_same_location_half_day(checkins)
    ret = []
    checkins.each_with_index do |ck,i|
      if i>0
        pre = ret[-1]
        pre.photos = [] if pre.photos.nil?
        if pre.sid == ck.sid && (pre.cati - ck.cati) < 3600*6
          ck.photos.each {|x| pre.photos << x} unless ck.photos.nil?
          next
        end
      end
      ret << ck
    end
    return ret
  end
  
  def self.init_city
    Checkin.all.each do |ck|
      next if ck.shop.nil?
      ck.city = ck.shop.city
      ck.save
    end
  end
  
end
