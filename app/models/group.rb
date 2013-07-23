# coding: utf-8
# 旅行团
class Group
  include Mongoid::Document
  field :name #名称 ， 默认为"线路名称＋团号"
  field :code #团号
  field :pass #加入时的默认密码，可以没有
  field :line_id, type: Moped::BSON::ObjectId #所属线路
  field :admin_sid, type:Integer #所属旅行社
  field :sid, type:Integer #旅行团对应的虚拟群, 该虚拟群shop的group_id=self._id
  field :fat, type: Date  #开始时间
  field :tat, type: Date #结束时间
  field :users, type:Array #团员 [ { name:姓名, phone:手机, sfz:身份证, id:用户id } ]
  field :hint #加入此团的认证提示信息
  field :invaildt, type:Integer #过期类型 1，时间到自动过期， 2 手动过期

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :to => :line
    option.delegate :name, :to => :shop
    option.delegate :name, :to => :admin_shop
  end
  
  after_create :gen_shop

  def gen_shop
    s = Shop.new
  	s.id = Shop.next_id
  	s.name = name
  	s.psid = admin_sid
    s.group_id = self.id
    s.save!
    self.update_attribute(:sid, s.id)
  end
  
  #加入一个群目前有两种情况
  #1. 婚礼现场，预设密码，输入密码进入
  #2. 旅行团，预设人员，输入手机号码进入
  def auth(uid, str)
    return password_auth(uid,str) if pass
    return phone_auth(uid, str)
  end

  def admin_shop
    @_admin_shop ||= Shop.find_by_id(admin_sid)
  end
  
  def password_auth(uid,str)
    if str==pass
      $redis.sadd("GROUP#{uid}", self.sid.to_i)
      return true
    else
      return false
    end
  end
  
  def phone_auth(uid, str)
    user = users.find{|hash| hash["phone"]==str && hash['id'].nil?}
    if user
      user.merge!({"id" => uid})
      self.save
      $redis.sadd("GROUP#{uid}", self.sid.to_i)
      return true
    else
      return false
    end
  end

  def line
    @_line ||= Line.find_by_id(line_id)
  end



  def shop
    @_shop ||= Shop.find_by_id(sid)
  end
  
  def self.find_by_phone(phone)
    Group.where({"users.phone" => phone})
  end

  # 虚拟群组过期
  def invalidate_old
    $redis.zrevrange("UA#{sid.to_i}",0,-1).each{|user| $redis.srem("GROUP#{user}", self.sid.to_i) }
  end

  def self.invalidate_old
    #TODO: 已过期的群，从key为“UA商家id"中找到所有用户，然后清除redis中的“GROUP#{uid}”数据
    #cronjob每天执行一次
    where({tat: 1.days.ago.to_date}).each{|group|  group.invalidate_old }
  end
  
end

