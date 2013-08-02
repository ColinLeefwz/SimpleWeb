# coding: utf-8

#<20275139,百度数据
#20275139~20347004, mapabc数据
#>20347004 osm数据
#>21000000 手动数据

class Shop
  include Gps
  include SearchScore
  include Mongoid::Document
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
  
  field :i, type: Boolean #用户添加的地点 已处理标记
  field :utype #用户添加的类型
  
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
    ShopNotice.where({shop_id: self.id}).last
  end
  
  def top4_photos
    Photo.where({room: self.id.to_i.to_s, hide: nil}).sort({od: -1, updated_at: -1}).limit(4).to_a
  end
  
  def photos
    Photo.where({room: self.id.to_i.to_s, hide: nil})
  end
  
  def photo_count
    Photo.where({room: self.id.to_i.to_s, hide: nil}).count
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
    Photo.where({room: self.id}).each{|photo| photo.set(:room, to_shop.id)}

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
  
  def safe_output
    hash = self.attributes.slice("name", "lo", "t")
    hash.merge!( {"lat"=>self.loc_first[0], "lng"=>self.loc_first[1], "address"=>"", "phone"=>"", "id"=>self.id.to_i} )
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
    ret = ""
    coupon = share_coupon
    ret += coupon.text if coupon
    #shop_wb = BindWb.wb_name(self.id)
    #ret += " @#{shop_wb}" if shop_wb
  end

  def safe_output_with_staffs
    safe_output.merge!( {"staffs"=> staffs, "notice" => nil} ).merge!({"photos" => top4_photos.map {|p| p.output_hash} }).merge!({text: default_text_when_photo})
  end  

  
  def show_t
    if self.t
      [["活动",0],["酒吧",1],["咖啡",2],["茶馆",3],["餐饮",4],["酒店",5],["休闲娱乐",6],["运动",7],["购物",8],["广场",9],["写字楼",10],["住宅",11],
        ["学校",12],["交通",13],['大型医院', 14],["美容美发",51],['公司', 52],['其他', 53]].detect{ |d| d[1] == self.t.to_i }.to_a.first
    else
      ''
    end
  end

  def logo
    ShopLogo.shop_logo(id)
  end

  def staffs
    Staff.only(:user_id).where({shop_id: self.id}).map {|x| x.user_id}
  end

  def notice
    ShopNotice.where(({shop_id: self.id})).last
  end
  
  def lord
    Lord.find_by_id(self.id)
  end

  def view_users(session_uid,start,size)
    ret = []
    users = Checkin.get_users_redis(id.to_i,start,size)
    lord = self.lord #TODO 性能优化
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
  
  def users
    Checkin.get_users_redis(id.to_i,0,-1).map {|x| User.find_by_id(x[0])}
  end
  
  def sub_shops
    return [] if shops.nil?
    return shops.map {|x| Shop.find_by_id(x)}.reject {|x| x.nil?}
  end

  def checkin_coupons
    Coupon.where({shop_id: self.id, hidden: {'$exists' => false}, t2: 1, rule: {"$ne" => nil}}).sort({_id: -1})
  end

  def checkin_eday_coupons
    Coupon.where({shop_id: self.id, hidden: {'$exists' => false}, t2: 1, rule: '0'}).sort({_id: -1})
  end

  def share_coupon
    Coupon.where({shop_id: self.id.to_i, hidden: nil, t2: '2'}).sort({_id: -1}).limit(1).to_a[0]
  end
  
  def send_coupon(user_id, limit=50)
    coupons = []
    #7月18 活动，获取附近活动商家的优惠券
    coupons += active_shop_coupons(user_id, limit)

    #旅行团 获取优惠券
    coupons +=  group_partners_coupons(user_id)

    coupons += self.checkin_coupons.select { |c| c.allow_send_checkin?(user_id) }
    coupons += allow_sub_coupons(user_id) if self.sub_coupon_by_share.nil?
    coupons.each{|coupon| coupon.send_coupon(user_id)}
    return if coupons.count == 0
    name = coupons.map { |coupon| coupon.name  }.join(',').truncate(50)
    return "收到#{coupons.count}张优惠券: #{name}" if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, self.id.to_i,user_id,"收到#{coupons.count}张优惠券: #{name}","coupon#{Time.now.to_i}","url='dface://record/coupon?forward'")
  end

  #旅行团 发送合作商家的优惠券
  #1.判断用户是否加入旅行团，
  #2. 获取旅行团在本次签到地点的合作商家的优惠券
  def group_partners_coupons(uid)
    coupon=[]
    $redis.smembers("GROUP#{uid}").each do |sid|
      begin
        coupon +=  Shop.find_by_id(sid).group.partners_coupons(self.id, uid)
      rescue
        next
      end
    end
    return coupon
  end


  #7月18 活动，获取附近活动商家的优惠券，
  def active_shop_coupons(user_id, limit)
    if $mansion1.include?(id.to_i) || $mansion2.include?(id.to_i)
      shops = Shop.find($cooperation_shops)
      loc = loc_first
      shops = shops.sort{|f,s| get_distance(f.loc_first, loc) <=> get_distance(s.loc_first, loc) }[0, limit]
      shops.inject([]){|f,s|  f + s.checkin_coupons.select { |c| c.allow_send_checkin?(user_id, :single => true) }}
    else
      []
    end
  end
  
  def allow_sub_coupons(user_id)
    coupons = []
    sub_shops.each do |shop|
      coupons += shop.checkin_eday_coupons.select { |c| c.allow_send_checkin?(user_id) }
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
    ShopFaq.where({sid: self.id}).sort({od: 1})
  end

  def faq(od)
    ShopFaq.where({sid: self.id, od: od}).first
  end

  def answer_text(msg)
    return  unless msg=='0' || msg =~ /^0[1-9]$/
    return answer_text_default if msg=='0'
    faq = self.faq(msg)
    if faq.nil?
      shop = Shop.find_by_id($llshop)
      faq = shop.faq(msg) if shop
    end
    return answer_text_default if faq.nil?
    if faq.img.blank?
      faq.text
    else
      "[img:faq#{faq._id}]#{faq.text}"
    end
  end
  
  def answer_text_default
    faqs = self.faqs.to_a
    if faqs.size==0
      return "本地点未启用数字问答系统" if self.id==$llshop
      shop = Shop.find_by_id($llshop)
      return "本地点未启用数字问答系统" if shop.nil?
      return "这地方怎么找不到人啊？"+shop.answer_text_default
    end
    "试试回复：\n" + faqs.map{|m| "#{m.od}=>#{m.title}."}.join("\n") 
  end

  def branchs
    Shop.where({psid: self._id})
  end

  def has_branch?
    Shop.where({psid: self._id}).limit(1).only(:_id).any?
  end

  def ban
    ShopBan.find2(self._id.to_i)
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
    return JSON.parse(Xmpp.get("api/gchat?room=#{self.id.to_i}"))
  end
  
  def history(skip,count)
    response = Xmpp.get("api/gchat2?room=#{self.id.to_i}&skip=#{skip}&count=#{count}")
    chats=  JSON.parse(response)
    rmd = RoomMsgDel.where({room: self.id.to_i}).distinct(:mid)
    chats.reject!{|c| rmd.include?(c[3])}
    return chats
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

        
end
