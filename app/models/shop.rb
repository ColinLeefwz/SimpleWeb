# encoding: utf-8

# coding: utf-8

#<20275139,百度数据
#20275139~20347004, mapabc数据
#>20347004 osm数据
#>21000000 手动数据

class Shop
  include Gps
  include SearchScore
  include Mongoid::Document
  store_in({:database => "shop"}) if Rails.env != "test"
  
  extend Similarity
  extend GpsOffset
  attr_accessor :lob
  
  field :_id, type: Integer
  field :pass
  field :name
  #field :lob, type:Array #百度地图上的经纬度  
  #field :loc, type:Array #google地图上的经纬度
  field :lo, type:Array #实际的经纬度
  field :city
  field :del,type:Integer   #删除标记, 如果被删除del=1，否则del不存在. 
  field :t ,type:Integer #脸脸的商家类型
  field :password
  field :utotal, type:Integer, default:0 #截至到昨天，该商家的用户总数
  field :shops, type:Array #子商家
  field :psid, type:Integer #总店id
  #field :osm_id #Open Street Map node id
  field :d, type:Integer #降权
  field :v, type:Integer #加权
  field :creator, type: Moped::BSON::ObjectId #该地点的创建者
  field :seller_id, type: Moped::BSON::ObjectId #负责该地点销售的人员
  field :group_id, type: Moped::BSON::ObjectId #旅行团id
  field :has_menu, type:Integer #该地点有自定义菜单, 1默认是聊天工具栏；2默认是菜单栏
  
  field :i, type: Boolean #用户添加的地点 已处理标记
  field :utype #用户添加的类型
  field :tid, type: Integer #旅行社编号
  
  field :sub_coupon_by_share, type: Boolean #进入大地点收到资地点签到优惠券的触发条件
  #默认nil 代表签到即可获得，true代表分享后获得，false代表不发送子地点优惠券。
  

  index({lo: "2d"})
  index({del: 1},{ sparse: true })
  index({d: 1},{ sparse: true })
  index({password: 1},{ sparse: true })
  index({v: 1},{ sparse: true })  
  index({city: 1, utotal:-1})

  with_options :allow_nil => true, :prefix => true do |option|
    option.delegate :name, :show_gender, :to => :seller
  end
  
  after_find do |obj|
    obj._id = obj._id.to_i
  end
  
  def self.default_hash
    {del: {"$exists" => false}}
  end
  
  def city_name
    City.city_name(city)
  end
  
  def city_fullname
    City.fullname(self.city)
  end

  
  def notice
    ShopNotice.find_by_id(self._id)
  end
  
  def coupons
    Coupon.where({shop_id: self.id}).last
  end
  
  def top4_photos
    PhotoCache.new.shop_photo_cache(self.id, 0, 5)[0,4]
  end
  
  def card_photo #显示为卡片效果的图片
    p = top4_photos[0]
    if p.od != nil
      p
    else
      nil
    end
  end
  
  def photos
    Photo.where({room: self.id.to_i.to_s, hide: nil})
  end
  
  def photo_count
    photos.count
  end

  def shop_photo
    Photo.where({user_id: "s#{self.id.to_i.to_s}", hide: nil}).sort({updated_at: -1})
  end

  def user
    return if self.creator.blank?
    user = User.find_by_id(self.creator)
  end

  def seller
    User.find_by_id(self.seller_id)
  end

  #合作商家
  def partners
    shop_partner = ShopPartner.find_by_id(id)
    (shop_partner&&shop_partner.partners) || []
  end

  #删除商家.
  def shop_del
    if utotal > 3
      throw "超过3人签到的商家不能直接删除"
    end
    if CheckinBssidStat.where({shop_id: self.id}).first
      throw "和WIFI绑定的商家不能直接删除"
    end    
    self.update_attribute(:del,1)
  end

  #合并到另一个地点中
  #合并步骤：１，　先合并签到，　２，合并聊天室发图，　３合并坐标，　４，删除当前商家
  #
  def merge_to(sid)
    to_shop = Shop.find(sid)
    #合并签到
    Checkin.where(sid: self.id).each{|checkin|  checkin.set(:sid, to_shop.id)}
    #合并聊天室发图
    Photo.where({room: self.id.to_s}).each{|photo| photo.set(:room, to_shop.id)}

    #３合并坐标
    to_lo = to_shop.lo.to_a
    to_lo = [to_lo] if to_lo.first.is_a?(Float)
    from_lo = self.lo
    from_lo = [from_lo] if from_lo.first.is_a?(Float)
    to_shop.lo = (to_lo + from_lo).uniq
    to_shop.save

    #删除当前商家
    Del.insert(self)
  end
  
  #彻底删除商家
  def del_test_shop
    CheckinShopStat.del_with_redis(self.id)
    checkins.each {|x| x.destroy}
    self.destroy
  end

  def first_checkin_time
    f = Checkin.where({sid: self.id.to_i}).limit(1).only(:_id).first
    f && f._id.generation_time.localtime.strftime("%Y-%m-%d %H:%M")
  end
  
  def checkins
    Checkin.where({sid:self.id})
  end

  #是否可以删除用户创建的地点。
  def destory_custom?
    checkins.distinct(:uid).size <= 1
  end
  
  def group
    Group.find_by_id(group_id)
  end
  
  def group_hint
    hint = group.hint
    return hint if hint
    "请输入验证信息:"
  end
  
  def group_hash(uid)
    return {} unless group_id
    return {} if $redis.sismember("GROUP#{uid}",self.id.to_i) #已加入群的用户不再要求输入hint
    return {"group_id"=>self.group_id, "group_hint"=>group_hint}
  end
  
  def total_user
    total = $redis.get("suac#{self.id.to_i}")
    total = self.utotal.to_i if total.nil?
    total
  end

  def checkin_users
    $redis.zrange("UA#{self.id}", 0, -1).map{|m| User.find_by_id(m)}.compact
  end
  
  def safe_output
    hash = self.attributes.slice("name", "lo", "t")
    hash.merge!( {"lat"=>self.loc_first[0], "lng"=>self.loc_first[1], "address"=>"", "phone"=>"", "id"=>self.id.to_i} )
    hash.merge!( {"user"=>total_user})
    hash.merge!( {"has_menu"=>self.has_menu.to_i}) if self.has_menu.to_i>0
    hash
  end
  
  def safe_output_with_users
    total,female = CheckinShopStat.get_user_count_redis(self._id)
    if total==0
      total = self.utotal
      female = total/2
    end
    male = total - female
    safe_output.merge!( {"user"=>total, "male"=>male, "female"=>female} )
  end
  
  def realtime_user_count
    total,female = CheckinShopStat.get_user_count_redis(self._id)
    total = self.utotal if total==0 && self.utotal>0
    total
  end
  
  def default_text_when_photo
    return '#我的2014心愿#' if self.id.to_s == "21838292"
    # return '#说出我的心愿#' if self.id.to_s == "21828958" 
    Rails.cache.fetch("SCPT#{self.id}") do
      ret = ""
      coupon = share_coupon
      ret += coupon.text if coupon && coupon.text
      ret
    end
  end
  
  def photo_filter
    return {} if true
    if self.id==21835409 	#脸脸测试专用
      {filter_name: "新年许愿", filters: ["http://s.dface.cn/zw.png"], filter_size: [640,640]}
    elsif self.id==21835801 	#技术测试专用的分店
      {filter_name: "紫微原点", filters: ["http://s.dface.cn/zw22.png","http://s.dface.cn/zw11.png"], filter_size: [640,640]}
    else
      {}
    end
  end

  def safe_output_with_staffs
    ret = safe_output
    ret.merge!( {"staffs"=> staffs_cache, "notice" => nil} )
    ret.merge!({"photos" => preset_p(top4_photos).map {|p| p.output_hash_to_user} })
    ret.merge!({text: default_text_when_photo})
    ret.merge!(photo_filter)
    ret
  end  
  
  def preset_p(photos)
    if self.t == 10 #写字楼
      p=Photo.find_by_id("5273013320f318640e000009") #嗮前台
      return photos if p.nil?
      p.set(:room, self.id)
      p.set(:od, 1)
      return [p] + photos[0..-2]
    end
    if self.t == 11 #住宅
      p=Photo.find_by_id("52721b67c90d8b4764000002") #嗮前台
      return photos if p.nil?
      p.set(:room, self.id)
      p.set(:od, 1)
      return [p] + photos[0..-2]
    end
    if self.t == 12 #学校
      p=Photo.find_by_id("52721b67c90d8b4764000002") #嗮桌面
      return photos if p.nil?
      p.set(:room, self.id)
      p.set(:od, 1)
      return [p] + photos[0..-2]
    end
    return photos
  end


  def preset_p2(photos)
    #餐厅
    rsp, t = Rails.cache.fetch('preset_value'){"0;#{Time.now.to_i}"}.split(/;/)
     if (Time.now.to_i-t.to_i) > (7*24*60*60) #大于7天， 换预置图；
      rsp += 1
      Rails.cache.write('preset_value', "#{rsp};#{Time.now.to_i}")
     end
    case self.t.to_i
    when 10 #写字楼 => 写字楼预置区
      sid = 21837807
    when 11 #住宅 => 小区预置区
      sid = 21837797  
    when 12 #学校 => 学校预置区
      sid = 21837805
    when 2 #咖啡 => 咖啡馆预置区
      sid = 21837800
    when 1 #酒吧 => 酒吧预置区
      sid = 21837801
    when 5 #酒店 => 酒店预置区
      sid = 21837802
    when 8 #购物 => 商场预置区
      sid = 21837803
    when 13 #交通 => 车站机场预置区
      sid = 21837806
    else
      types = self.type.to_s.split(/;/)
      if types.include?('ktv') #KTV预置区
        sid = 21837799
      elsif types.include?('电影院')  # 电影院预置区
        sid = 21837804
      elsif (types&['西餐厅', '中餐厅', '外国餐厅', '快餐厅']).any?
        sid = 21837798  #餐厅预置区 
      else
        return photos
      end
    end
    shop = Shop.find_by_id(sid)
    return photos if shop.nil?
    p = shop.photos.skip(rsp%photo_count).limit(1).to_a[0]
    return photos if p.nil?
    p.set(:room, self.id)
    p.set(:od, 1)
    return [photo] + photos[0..-2]
  end


  
  def show_t
    if self.t
      [["活动",0],["酒吧",1],["咖啡",2],["茶馆",3],["餐饮",4],["酒店",5],["休闲娱乐",6],["运动",7],["购物",8],["广场",9],["写字楼",10],["住宅",11],
        ["学校",12],["交通",13],['大型医院', 14],["美容美发",51],['公司', 52],['其他', 53]].detect{ |d| d[1] == self.t.to_i }.to_a.first
    else
      ''
    end
  end

  #旅行社找合作商家的id
  def self.find_by_tid(tid)
    where({tid: tid}).limit(1).first
  end

  def logo
    ShopLogo.shop_logo(id)
  end

  def staffs
    Staff.only(:user_id).where({shop_id: self.id}).map {|x| x.user_id}
  end
  
  def staffs_cache
    Rails.cache.fetch("STF#{self.id}") do
      staffs
    end
  end
  
  def lord
    Lord.find_by_id(self.id, "0")
  end

  def view_users(session_uid,start,size)
    ret = []
    users = Checkin.get_users_redis(id.to_i,start,size)
    if users.size>3
      lord = self.lord
    else
      lord = nil
    end
    if start==0
      users = [[session_uid,Time.now.to_i]] + users.delete_if{|x| x[0].to_s==session_uid.to_s}
      if lord
        ld = users.find{|x| x[0].to_s==lord.uid.to_s}
        if ld
          users = [ld] + users.delete_if{|x| x[0].to_s==lord.uid.to_s}
        end
      end
    end
    users.each do |uid,cat|
      u = User.find_by_id(uid)
      next if u.nil?
      next if u.forbidden?
      #next if u.block?(session_uid)
      next if u.invisible.to_i>=2
      hash = u.safe_output(session_uid).merge!({time:Checkin.time_desc(cat)})
      hash.merge!({lord:1}) if lord && lord.uid.to_s==uid.to_s
      hash.merge!({lord:1}) if creator && creator.to_s==uid.to_s
      ret << hash
    end
    diff = users.size-ret.size
    if diff>0 #有拉黑或隐身的用户，用马甲帐号代替
      start = rand($fakeusers1.size-diff)
      if ret && ret.size>0
        time = ret[-1]["time"]
      else
        time = "3 days"
      end
      $fakeusers1[start,diff].each do |uid|
        u = User.find_by_id(uid)
        hash = u.safe_output(session_uid).merge!({time: time})
        ret << hash
      end
    end
    ret
  end

  def view_user6s(session_uid)
    ret = []
    users = Checkin.get_users_redis(id.to_i,0,15)
    users = users.delete_if{|x| x[0].to_s==session_uid.to_s}
    return [] if users.size<3
    output = lambda do |uid,sex|
      u = User.find_by_id(uid)
      return if sex && u.gender!=sex
      return if u.nil?
      return if u.forbidden?
      return if u.invisible.to_i>=2
      hash = u.safe_output(session_uid)
      ret << hash
    end
    users[0,3].each do |uid,cat|
      output.call(uid,nil)
    end
    return ret if users.size==3
    users[3..-1].each do |uid,cat|
      output.call(uid, 2)
      return ret if ret.size>=6
    end
    users[3..-1].each do |uid,cat|
      output.call(uid, 1)
      return ret if ret.size>=6
    end
    ret
  end
    
  def users
    Checkin.get_users_redis(id.to_i,0,-1).map {|x| User.find_by_id(x[0])}
  end
  
  def sub_shops
    return [] if shops.nil?
    return shops.map {|x| Shop.find_by_id(x)}.reject {|x| x.nil?}
  end

  #签到类的所有优惠券
  def checkin_coupons
    Coupon.where({shop_id: self.id, hidden: {'$exists' => false}, t2: 1, rule: {"$ne" => nil}}).sort({_id: -1})
  end

  #签到类的每日分享优惠券
  def checkin_eday_coupons
    Coupon.where({shop_id: self.id, hidden: {'$exists' => false}, t2: 1, rule: '0'}).sort({_id: -1})
  end

  #分享类优惠券, scd 触发条件，
  def share_coupon(scd=0)
    coupon = Coupon.where({shop_id: self.id.to_i, hidden: nil, t2: '2'}).sort({_id: -1}).limit(1).to_a[0]
    return nil if coupon.nil?
    coupon.scd.to_i == scd ? coupon : nil

  end

  
  def send_coupon(user_id, limit=50)
    coupons = []
    #7月18 活动，获取附近活动商家的“每日签到优惠券”
    coupons += active_shop_coupons(user_id, limit)

    #旅行团 获取旅游景点上合作商家的 “每日签到优惠券”
    coupons +=  group_partners_coupons(user_id)

    #当前地点的合作商家的“每日签到优惠券”
    coupons += partner_coupons(user_id)

    #总店的“每日签到优惠券”
    coupons += pshop_coupon(user_id)

    #当前商家的签到优惠券
    coupons += self.checkin_coupons.select { |c| c.allow_send_checkin?(user_id) }

    #内部地点的“每日签到优惠券”
    coupons += allow_sub_coupons(user_id) if self.sub_coupon_by_share.nil?

    if $mansion3.include?(self.id)
      ["52fc278620f318cb4a000009"].each do |cp|
        coupon1 = Coupon.find_by_id(cp)
        if coupon1.allow_send_checkin?(user_id, :single => true)
          coupon1.send_coupon(user_id,nil,self.id)
        end
      end
    end
    coupons.each{|coupon| coupon.send_coupon(user_id,nil,self.id)}
    return if coupons.count == 0
    name = coupons.map { |coupon| coupon.name  }.join(',').truncate(50)
    str = "恭喜#{User.find_by_id(user_id).name}！收到#{coupons.count}张优惠券: #{name},马上领取吧！"
    return str if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, self.id.to_i,user_id,str,"coupon#{Time.now.to_i}","url='dface://record/coupon?forward'")
  end

  #总店的优惠券
  def pshop_coupon(uid)
    return [] if (pshop = Shop.find_by_id(psid)).nil?
    pshop.checkin_eday_coupons.select { |c| c.allow_send_checkin?(uid) }
  end

  #旅行团 发送合作商家的优惠券
  #1.判断用户是否加入旅行团，
  #2.判断旅行团是否生效
  #3. 获取旅行团在本次签到地点的合作商家的优惠券
  def group_partners_coupons(uid)
    $redis.smembers("GROUP#{uid}").each do |sid|
      begin
        group = Shop.find_by_id(sid).group
        return  group.partners_coupons(self.id, uid) if group && group.effectual?
      rescue
        next
      end
    end
    return []
  end

  #合作商家发送“签到优惠券”, 只发合作商家的每日签到优惠， 并且合作商家优惠券没有使用的话不发送
  def partner_coupons(uid)
    return [] if  $travel.include?(self.id.to_i)
    coupons = []
    partners.each do |partner|
      shop = Shop.find_by_id(partner[0])
      coupons += shop.checkin_eday_coupons.select { |c| c.allow_send_checkin?(uid, :single => true) } if shop
    end
    return coupons
  end


  #7月18 活动，获取附近活动商家的优惠券，
  def active_shop_coupons(user_id, limit)
    if $mansion1.include?(id.to_i) || $mansion2.include?(id.to_i)
      shops = Shop.find($cooperation_shops)
      loc = loc_first
      shops = shops.sort{|f,s| get_distance(f.loc_first, loc) <=> get_distance(s.loc_first, loc) }[0, limit]
      shops.inject([]){|f,s|  f + s.checkin_eday_coupons.select { |c| c.allow_send_checkin?(user_id, :single => true) }}
    else
      []
    end
  end
  
  def allow_sub_coupons(user_id)
    coupons = []
    sub_shops.each do |shop|
      coupons += shop.checkin_eday_coupons.select { |c| c.allow_send_checkin?(user_id, :single => true) }
    end
    coupons
  end
  
  def latest_coupons(n=1)
    coupons = Coupon.where({shop_id: self.id}).sort({_id: -1}).limit(n).to_a
  end

  def no_active?
    Coupon.where({shop_id: self.id, hidden: nil}).limit(1).only(:_id).blank?
  end

  def no_faq?
    ShopFaq.where({sid: self.id}).limit(1).only(:_id).blank?
  end

  def faqs
    ShopFaq.where({sid: self.id, od: {"$ne" => nil }}).sort({od: 1})
  end

  def faq(od)
    ShopFaq.where({sid: self.id, od: od}).first
  end
  
  def find_faq_by_num(msg)
    faqs = self.faqs
    if faqs.blank?
      shop = self.pshop || Shop.find_by_id($llshop)
    else
      shop = self
    end
    shop ? shop.faq(msg) : nil
  end

  def find_article_by_keywords(msg)
    MobileArticle.where({sid:self.id, kw:msg}).first
  end
  
  def find_faqs
    faqs = self.faqs
    return faqs if faqs.size>0
    return self.pshop.faqs if self.pshop
    #return Shop.find_by_id($llshop).faqs  if self.total_user==0
    return nil
  end

  def mobile_articles
    MobileArticle.where({sid: self.id}).sort({_id: -1})
  end

  def mobile_banners
    MobileBanner.where({sid:self.id}).sort({_id: -1})
  end

  def answer_text(msg)
    return nil unless msg=='0' || msg =~ /^0[1-9]$/
    return answer_text_default if msg=='0'
    faq = find_faq_by_num(msg)
    return answer_text_default if faq.nil?
    faq
  end

  # 是否对用户启用预置问答
  def preset?(user)
    is_kx_user?(user.id) && self.no_faq?
    # user && (user.cat+3.days) > Time.now && self.no_faq?
  end

  #问答
  def faqs_text(user)
    preset?(user) ? pre_faqs(user) : answer_text_default
  end

  #预置问答
  def pre_faqs(user)
    us = checkin_users 
    pre = "hi，#{user.name}，欢迎来到#{self.name}😊试试回复："
    pre += "\n01=>来到这儿可以做什么？\n"
    pre += "02=>如何找到更多的小伙伴？\n" 
    pre += "03=>#{self.name}のかみ速配.\n" if us.select{|m| m.gender != user.gender }.any?
    pre
  end
  
  #正常情况下问答
  def answer_text_default
    faqs = self.find_faqs.to_a
    return "本地点未启用数字问答系统" if faqs.blank?
    "试试回复：\n" + faqs.map{|m| "#{m.od}=>#{m.title}"}.join("\n")
  end

  def weixin_answer_text(msg)
    article = find_article_by_keywords(msg)
    return nil if article.nil?
    article
  end

  def branchs
    Shop.where({psid: self._id})
  end

  def has_branch?
    Shop.where({psid: self._id}).limit(1).only(:_id).any?
  end

  #总店
  def pshop
    Shop.find_by_id(psid) unless psid.blank?
  end

  def ban
    ShopBan.find_by_id(self._id.to_i)
  end

  def ban_user(uid)
    ban && ban.users.to_a.index(uid)
  end

  def lob_to_lo
    Shop.lob_to_lo self.lob
  end

  def lo_to_lob
    Shop.lo_to_lob(lo.first.is_a?(Array) ? lo.first : lo)
  end

  def get_city
    if lo.nil?
      return Shop.get_city(self.lob)
    else
      return Shop.get_city(self.loc_first)
    end
  end

  def self.get_city(lo)
    hash = "%.2f%.1f" %  lo
    field = ("%.2f" %  lo[1])[-1..-1]
    city = $redis.hget(hash,field)
    city = get_ex_city(lo) if city.nil?
    if city.nil?
      Xmpp.error_notify("经纬度－>城市数据没有:#{lo}")
      hx = $redis.hgetall(hash)
      city = hx.values[0] if hx
    end
    city
  end
  
  def self.get_ex_city(lo)
    key = "%.0f,%.0f" % lo
    key = "oversea#{key}"
    $redis.get(key)
  end
  
    
  def self.get_city_mongo(loc)
    shop = Shop.only(:city).where({lo:{'$near' => loc,'$maxDistance' => 0.1}, city:{'$exists' => true}}).first
    shop.nil?? nil : shop.city
  end

  def gchat
    JSON.parse(Xmpp.get("api/gchat2?room=#{self.id.to_i}&skip=0&count=200"))
  rescue
    return []
  end

  #消息返回格式[uid, text, time, id]
  def history(skip,count)
    #人才市场
    return [] if self.id == 21834120 
    skip = 0 if skip<0
    begin
      response = Xmpp.get("api/gchat2?room=#{self.id.to_i}&skip=#{skip}&count=#{count}")
    rescue RestClient::ServerBrokeConnection => e
      #Xmpp.error_notify("获取#{self.name}：#{self.id}-#{skip}-#{count}的聊天历史失败") if total_user.to_i>2
      return []
    end
    JSON.parse(response)
  end

  def lines
    Line.where({admin_sid: self.id}).sort({_id: -1})
  end
  
  def self.next_id
    nid = $redis.incr("SHOP_NID")
    if nid==1
      nid = Shop.last.id.to_i+1
      $redis.set("SHOP_NID",nid)
    end
    nid
  end
  
  #将子商家的经纬度合并到主商家中
  def merge_subshops_locations
    arr = merge_locations(sub_shops)
    self.update_attributes!({lo:arr})
  end


  
  def merge_shop_ids(ids)
    arr = merge_locations(ids.map{|id| Shop.find_by_id(id)})
    self.update_attributes!({lo:arr})
  end

  def show_lob
    return '' unless self.lob.is_a?(Array)
    if self.lob.first.is_a?(Array)
      self.lob.map{|m| m.reverse.join(',')}.join(' ; ')
    else
      self.lob.reverse.join(',')
    end
  end

  #旅行社 返回的商家信息
  def travel_attrs
    attributes.slice("name", "lo").merge("dface_id" => self.id, "id" => self.tid, "type" => self.show_t, "addr" => self.addr)
  end
  
  
  #将一些定位无关的商家信息保存到独立的ShopInfo中，为保持兼容性，添加一些代理addr等的方法。
  def info
    ShopInfo.find_primary(self.id)
  end
  
  def addr
    info.nil?? nil:info.addr
  end

  def phone
    info.nil?? nil:info.phone
  end

  def contact
    info && info.contact
  end
  
  def tel
    info.nil?? nil:info.tel
  end
  
  def type
    info.nil?? nil:info.type
  end
  
  def self.node(ip)
    nodes = Shop.collection.database.session.cluster.nodes
    nod = nodes.find{|x| x.ip_address==ip}
    return nod if nod
    return nodes[0]
  end
  
  #使用内存数据库查询商家表
  def self.where2(hash, options={})
    if Rails.env == "production"
      options.merge!({flags: [:slave_ok]})
      node("10.135.44.107").query("shop","shops", hash, options).documents.map {|x| Shop.instantiate(x)}
    else
      ca = Shop.where(hash["$query"]|| hash)
      options.each{|k, v| ca= ca.send(k,v)}
      ca.send("sort", hash["$orderby"]|| {})
      ca
    end
  end

  def has_logo?
    Rails.cache.fetch("HAS_LOGO#{self.id}") do
      self.logo != nil
    end
  end
  
  def msg_sender
    return "s#{self.id}" if self.password && self.t && self.has_logo?
    return $gfuid
  end

  def has_food_purview?
    /测试|脸脸/ =~ self.name || self.id.to_s == '21832844' || self.id.to_s == '21837941' ? true : false
  end

  def has_trade_purview?
    self.id.to_s == '21838725' || self.id.to_s == '21835409' ? true : false
  end
  
  def in_shop?(lo,acc=0)
    diff = self.min_distance(self,lo)
    if acc==0
      return diff < 3000
    else
      return diff < 1000 + acc.to_f
    end
  end

  #大地点上下左右坐标范围加大,每次time 各变化0.005
  def add_range(time=1)
    return if !self.lo.first.is_a?(Array)
    loc = self.loc_first
    1.upto(time) do |t|
      offs = t*0.005
      self.lo << [loc[0]+offs, loc[1]]
      self.lo << [loc[0]-offs, loc[1]]
      self.lo << [loc[0], loc[1]+offs]
      self.lo << [loc[0], loc[1]-offs]
    end 
    self.lo = self.lo.uniq
    self.save
  end
  
  
end