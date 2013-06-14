# coding: utf-8
# 旅行线路，以后也可以用作火车线路等
class UserActive
  include Mongoid::Document
  field :_id, type:String 
  field :data, type:Hash # [ { time:相对时间，lo:经纬度, sid:地点id } ]


  #user_active.id 获取要查询的时间段
  def ttoid(uat)
    year, month,week =  uat.split("-").map{|m| m.to_i}
    if week
      sday = (week-1)*7
      sday =(sday ==0 ? 1 : sday)
      stid = Time.new(year, month, sday)
      eday = week*7
      begin
        etid = Time.new(year, month, eday).end_of_day
      rescue
        etid = Time.new(year,month).end_of_day
      end
    elsif month
      stid = Time.new(year,month)
      etid = stid.end_of_month
    elsif year
      stid = Time.new(year)
      etid = stid.end_of_year
    end
    [stid.to_i.to_s(16).ljust(24,'0'), etid.to_i.to_s(16).ljust(24,'0')]
  end

  def register_user_num
    @rstid, @retid = ttoid(self.id)
    User.where( {_id: {'$gte' => @rstid, "$lte" => @retid}, auto: nil}).count
  end

  def checkin_user_num(ctime)
    cstid, cetid = ttoid(ctime)
    Checkin.where({_id: {'$gte' => @rstid, "$lte" => @retid}, uid: {'$gte' => cstid, "$lte" => cetid}}).distinct("uid").count
  end

  def do_count(uaid)
    self._id = uaid
    data = {'register' =>  register_user_num}
    UserActive.where(_id: {"$lt" => self._id}).each do |ua|
      data.merge!(ua.id => checkin_user_num(ua.id))
    end
    self.data = data
    self.save
  end

  def self.do_count(uaid = nil)
    if uaid.nil?
      time = Time.now
      day = time.day
      return day%7 != 1
      time = time - 1.days
      uaid= "#{time.year}-#{time.month}-#{(time.day+6)/7}"
    end
    ua = self.new
    ua.do_count(uaid)
  end

end

