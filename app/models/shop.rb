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
  
  field :_id, type: Integer
  field :pass
  field :name
  field :lob, type:Array #百度地图上的经纬度  
  #field :loc, type:Array #google地图上的经纬度
  field :lo, type:Array #实际的经纬度
  field :city
  field :del,type:Integer   #删除标记, 如果被删除del=1，否则del不存在. 
  field :t                #脸脸的商家类型
  field :password
  field :utotal, type:Integer, default:0 #截至到昨天，该商家的用户总数
  field :uftotal, type:Integer, default:0 #截至到昨天，该商家的女性用户总数
  field :shops, type:Array #子商家
  field :psid, type:Integer #总店id
  #field :osm_id #Open Street Map node id
  field :d, type:Integer #降权
  field :v, type:Integer #加权
  field :creator, type: Moped::BSON::ObjectId #该地点的创建者


  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6, :allow_nil => true

  index({lo: "2d"})
  index({del: 1},{ sparse: true })
  index({d: 1},{ sparse: true })
  index({password: 1},{ sparse: true })
  index({v: 1},{ sparse: true })  
  index({city: 1, utotal:-1})

  
  def self.default_hash
    {del: {"$exists" => false}}
  end
  
  def city_name
    City.city_name(city)
  end
  
  def city_fullname
    city = City.where({code:self.city}).first
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

  #删除商家.
  def shop_del
    self.update_attribute(:del,1)
  end
  
  #彻底删除商家
  def del_test_shop
    CheckinShopStat.del_with_redis(self.id)
    checkins.each {|x| x.destroy}
    self.destroy
  end

  def first_checkin
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
      female = self.uftotal
    end
    male = total - female
    safe_output.merge!( {"user"=>total, "male"=>male, "female"=>female} )
  end
  
  def realtime_user_count
    total,female = CheckinShopStat.get_user_count_redis(self._id)
    total = self.utotal if total==0 && self.utotal>0
    total
  end

  def safe_output_with_staffs
    safe_output.merge!( {"staffs"=> staffs, "notice" => nil} ).merge!({"photos" => top4_photos.map {|p| p.output_hash} })
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
    Staff.where({shop_id: self.id}).map {|x| x.user_id}
  end

  #  def notice
  #    ShopNotice.where({shop_id: self.id, effect: true}).inject("") {|mem,x| mem << x.title }
  #  end

  def notice
    ShopNotice.where(({shop_id: self.id})).last
  end

  #从CheckinShopStat获得昨天以前的用户签到记录，从redis中获得今天的用户签到记录，然后合并
  def user_last_checkins(start,size)
    users1 = Checkin.get_users_redis(id.to_i)
    uids = users1.map {|arr| arr[0]}
    css = CheckinShopStat.find_by_id(id.to_i)
    unless css.nil?
      users2 = css.users.map {|k,v| [k,v[1].generation_time.to_i]} # ObjectId("k") => k
      users2.sort!{|a,b| b[1] <=> a[1]}
      users2.each {|arr| users1 << arr unless uids.member?(arr[0])}
    end
    #ssu = ShopSinaUser.find_by_id(id.to_i)
    #unless ssu.nil?
    #  ssu.users.each {|x| users1 << [x,(Time.now-10.days).to_i]}
    #end
    users1[start,size] #TODO: 分页判断
  end

  def users(session_uid,start,size)
    #TODO: 性能优化，目前当用户大于10个时，执行耗时在半秒以上。
    #Benchmark.measure {Shop.find_by_id(4928288).users(User.last._id)} 
    ret = []
    user_last_checkins(start,size).each do |uid,cat|
      u = User.find_by_id(uid)
      next if u.nil?
      next if u.forbidden?
      next if u.block?(session_uid)
      ret << u.safe_output_with_relation(session_uid).merge!({time:Checkin.time_desc(cat)})
    end
    ret
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
    Coupon.where({shop_id: self.id.to_i, hidden: nil, t2: '2'}).sort({_id: -1}).limit(1).first
  end
  
  def send_coupon(user_id)
    return if $redis.zrange("ckin#{self.id.to_i}", 0, -1).include?(user_id.to_s)
    coupons = []
    Coupon.gen_demo(self.id) if self.latest_coupons.empty? && (ENV["RAILS_ENV"] != "production" )
    coupons += self.checkin_coupons.select { |c| c.allow_send_checkin?(user_id) }
    Shop.find(self.id).sub_shops.each{|shop| coupons += shop.checkin_eday_coupons.to_a }

    coupons.each{|coupon| coupon.send_coupon(user_id)}
    return if coupons.count == 0
    name = coupons.map { |coupon| coupon.name  }.join(',').truncate(50)
    xmpp2 = Xmpp.gchat(self.id.to_i,user_id,"收到#{coupons.count}张优惠券: #{name}")
    return "收到#{coupons.count}张优惠券: #{name}" if ENV["RAILS_ENV"] != "production"
    logger.info(xmpp2)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2)
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

  

  def get_city
    rl = lo || lob_to_lo
    return '' if rl.to_a.length != 2
    Shop.get_city rl
  end
  
  def self.get_city(loc)
    Shop.where({lo:{'$near' => loc }}).first.city
  end

  def self.lob_to_lo(lob)
    return lob if ENV["RAILS_ENV"] != "production"
    tmp = Mongoid.session(:dooo)[:offsetbaidus].where({loc: {'$near' => lob}}).first
    [lob[0]-tmp['d'][0],lob[1]-tmp['d'][1]];
  end

  def self.lo_to_lob(lo)
    return lo if ENV["RAILS_ENV"] != "production"
    tmp = Mongoid.session(:dooo)[:offsetbaidus].where({loc:{'$near' => lo}}).first
    [lo[0]+tmp['d'][0], lo[1]+tmp['d'][1] ];
  end
  
  def lob_to_lo
    Shop.lob_to_lo self.lob
  end

  def lo_to_lob
    Shop.lo_to_lob self.lo
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
  
  def self.next_id
    Shop.all.sort({_id: -1}).limit(1).to_a[0].id.to_i+1
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
  
  def tel
    info.nil?? nil:info.tel
  end
  
  def type
    info.nil?? nil:info.type
  end
        
end
