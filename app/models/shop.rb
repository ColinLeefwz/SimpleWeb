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
  
  field :_id, type: Integer
  field :pass
  field :name
  field :lob, type:Array #百度地图上的经纬度  
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
  
  field :i, type: Boolean #用户添加的地点 已处理标记

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
    city = City.where({code:self.city}).limit(1).first
    return "" if city.nil?
    city.s.to_s + city.name.to_s
  end


  
  def notice
    ShopNotice.where({shop_id: self.id}).last
  end
  
  def top4_photos
    Photo.where({room: self.id.to_i.to_s}).sort({updated_at: -1}).limit(4).to_a
  end
  
  def photos
    Photo.where({room: self.id.to_i.to_s})
  end
  
  def photo_count
    Photo.where({room: self.id.to_i.to_s}).count
  end

  def user
    return if self.creator.blank?
    user = User.find_by_id(self.creator)
  end

  def seller
    User.find_by_id(self.seller_id)
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
  
  def safe_output
    self.attributes.slice("name", "lo", "t").merge!( {"lat"=>self.loc_first[0], "lng"=>self.loc_first[1], "address"=>"", "phone"=>"", "id"=>self.id.to_i} )
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
    lord = self.lord
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
      ret << hash
    end
    diff = users.size-ret.size
    if diff>0 #有拉黑或隐身的用户，用马甲帐号代替
      start = rand($fakeusers1.size-diff)
      $fakeusers1[start,diff].each do |uid|
        u = User.find_by_id(uid)
        hash = u.safe_output(session_uid).merge!({time: ret[-1]["time"]})
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
    Coupon.where({shop_id: self.id, hidden: {'$exists' => false}, t2: 1}).sort({_id: -1})
  end

  def checkin_eday_coupons
    Coupon.where({shop_id: self.id, hidden: {'$exists' => false}, t2: 1, rule: '0'}).sort({_id: -1})
  end

  def share_coupon
    Coupon.where({shop_id: self.id.to_i, hidden: nil, t2: '2'}).sort({_id: -1}).limit(1).to_a[0]
  end
  
  def send_coupon(user_id)
    coupons = []
    coupons += self.checkin_coupons.select { |c| c.allow_send_checkin?(user_id) }
    sub_shops.each do |shop|
      coupons += shop.checkin_eday_coupons.select { |c| c.allow_send_checkin?(user_id) }
    end
    coupons.each{|coupon| coupon.send_coupon(user_id)}
    return if coupons.count == 0
    name = coupons.map { |coupon| coupon.name  }.join(',').truncate(50)
    return "收到#{coupons.count}张优惠券: #{name}" if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, self.id.to_i,user_id,"收到#{coupons.count}张优惠券: #{name}","coupon#{Time.now.to_i}","url='dface://record/coupon?forward'")
  end
  
  def latest_coupons(n=1)
    coupons = Coupon.where({shop_id: self.id}).sort({_id: -1}).limit(n).to_a
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
    return answer_text_default if faq.nil?
    if faq.img.blank?
      faq.text
    else
      "[img:faq#{faq._id}]#{faq.text}"
    end
  end
  
  def answer_text_default
    faqs = self.faqs.to_a
    return "本地点未启用数字问答系统" if faqs.size==0
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
    $redis.hget(hash,field)
  end
    
  def self.get_city_mongo(loc)
    shop = Shop.only(:city).where({lo:{'$near' => loc,'$maxDistance' => 0.1}, city:{'$exists' => true}}).first
    shop.nil?? nil : shop.city
  end

  def gchat
    $xmpp_ips.count.times do |t|
      url = "http://#{$xmpp_ips[t]}:5280/api/gchat?room=#{self.id.to_i}"
      begin
        return JSON.parse(RestClient.get(url))
      rescue
        next
      end
    end
  end
  
  def history(skip,count)
    $xmpp_ips.count.times do |t|
      url = "http://#{$xmpp_ips[t]}:5280/api/gchat2?room=#{self.id.to_i}&skip=#{skip}&count=#{count}"
      begin
        return JSON.parse(RestClient.get(url))
      rescue
        next
      end
    end
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
