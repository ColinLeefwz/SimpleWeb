# coding: utf-8
# 旅行团
class Group
  include Mongoid::Document
  #  field :_id
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
  
  #  before_create :gen_shop

  #签到地点在旅行团线路上， 获取路线上的本次签到地点的合作商家的优惠券
  #sid签到地点id， uid => 用户id
  def partners_coupons(sid,uid)
    shop_line_partent = ShopLinePartner.find_by_id(line_id)
    partners = shop_line_partent.partners
    return [] unless (pids = partners[sid.to_s])
    shops = Shop.find_by_id(pids)
    shops.inject([]){|f,s|  f + s.checkin_coupons.select { |c| c.allow_send_checkin?(uid, :single => true) }}
  rescue
    []
  end


  #旅行团是否在有效时间内
  def effectual?
    fatime = self.fat.to_time
    tatime = self.tat.to_time.end_of_day
    Time.now.between?(fatime, tatime)
  rescue
    true
  end

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
    Shop.find_by_id(admin_sid)
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
    Line.find_by_id(line_id)
  end

  #批量认证已经有的用户到组中
  def bat_phone_auth
    return if self.users.blank?
    self.users.map{|m| m['phone']}.each do |ph|
      user = User.find_by_phone(ph)
      self.phone_auth(user.id, ph)  if user
    end
  end

  #自动建立一个问答系统
  def create_shop_faq
    line = self.line
    shop = self.shop
    if line && shop
      ShopFaq.create(sid: shop.id, title: '旅游线路', text: "点击下面链接查看路线详情:http://shop.dface.cn/shop_groups/mobile?id=#{self.id}", od: '01')
    end
  end

  def shop
    Shop.find_by_id(sid)
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

