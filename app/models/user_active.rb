# coding: utf-8

class UserActive
  include Mongoid::Document
  field :_id, type:String 
  field :data, type:Hash # [ { 以前的时间点或register: 以前时间点内注册并且在当前id内签到的用户数量 或 当前id内注册量 } ]


  #user_active.id 获取要查询的时间段的id
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

  #根据id 计算时间段内注册的用户
  def register_user_num
    @rstid, @retid = ttoid(self.id)
    User.where( {_id: {'$gte' => @rstid, "$lte" => @retid}, auto: nil}).count
  end

  #传入时间， 计算在传入的时间段内注册，并且当前在user_active.id 内签到的用户数
  def checkin_user_num(ctime)
    cstid, cetid = ttoid(ctime)
    Checkin.where({_id: {'$gte' => @rstid, "$lte" => @retid}, uid: {'$gte' => cstid, "$lte" => cetid}}).distinct("uid").count
  end

  #计算当前user_active 并保存到mongo中
  def do_count(uaid)
    self._id = uaid
    data = {'register' =>  register_user_num}
    UserActive.where(_id: {"$lt" => self._id}).each do |ua|
      data.merge!(ua.id => checkin_user_num(ua.id))
    end
    self.data = data
    self.save
  end

  #类方法， cron的调用接口， 月初或每月的每周后一天执行。
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

