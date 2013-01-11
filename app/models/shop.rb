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
  field :tel 
  field :city
  #  field :phone
  field :del,type:Integer   #删除标记, 如果被删除del=1，否则del不存在. 
  field :addr
  field :t                #脸脸的商家类型
  field :password
  field :utotal, type:Integer, default:0 #截至到昨天，该商家的用户总数
  field :uftotal, type:Integer, default:0 #截至到昨天，该商家的女性用户总数
  field :shops, type:Array #子商家
  #field :osm_id #Open Street Map node id
  field :d, type:Integer #降权
  field :v, type:Integer #加权

  #field :cc, type:Integer  #点评的评论数
  field :type              #从mapabc导入的商家类型
  field :d #降低权重
  field :v #加权距离0-100

  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6, :allow_nil => true

  index({lo: "2d"})
  index({del: 1},{ sparse: true })
  index({city: 1})
  index({utotal:-1})
  
  def self.default_hash
    {del: {"$exists" => false}}
  end


  def self.find_by_id(id)
    begin
      self.find(id)
    rescue
      nil
    end
  end
  
  def notice
    ShopNotice.where({shop_id: self.id}).last
  end

  #删除商家.
  def shop_del
    self.update_attribute(:del,1)
  end
  
  def safe_output
    self.attributes.slice("name", "phone", "lo", "t").merge!( {"lat"=>self.loc_first[0], "lng"=>self.loc_first[1], "address"=>self.addr, "id"=>self.id.to_i} )
  end
  
  def safe_output_with_users
    total,female = CheckinShopStat.get_user_count_redis(self._id)
    male = total - female
    safe_output.merge!( {"user"=>total, "male"=>male, "female"=>female} )
  end

  def safe_output_with_staffs
    safe_output.merge!( {"staffs"=> staffs} ).merge!({"notice" => notice})
  end  

  
  def show_t
    if self.t
      ["活动","酒吧","咖啡","茶馆","餐饮","酒店","休闲娱乐","运动","购物","广场","写字楼","住宅","学校","交通"][self.t.to_i]
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

  def top_notice
    ShopTopNotice.where(({shop_id: self.id})).last
  end

  #从CheckinShopStat获得昨天以前的用户签到记录，从redis中获得今天的用户签到记录，然后合并
  def user_last_checkins(start,size)
    users1 = Checkin.get_users_redis(id.to_i)
    uids = users1.map {|arr| arr[0]}
    css = CheckinShopStat.find_by_id(id.to_i)
    unless css.nil?
      users2 = css.users.map {|k,v| [k[10..-3],v[1].generation_time.to_i]} # ObjectId("k") => k
      users2.sort!{|a,b| b[1] <=> a[1]}
      users2.each {|arr| users1 << arr unless uids.member?(arr[0])}
    end
    ssu = ShopSinaUser.find_by_id(id.to_i)
    unless ssu.nil?
      ssu.users.each {|x| users1 << [x,(Time.now-10.days).to_i]}
    end
    users1[start,size] #TODO: 分页判断
  end

  def users(session_uid,start,size)
    #TODO: 性能优化，目前当用户大于10个时，执行耗时在半秒以上。
    #Benchmark.measure {Shop.find(4928288).users(User.last._id)} 
    ret = []
    user_last_checkins(start,size).each do |uid,cat|
      u = User.find2(uid)
      next if u.block?(session_uid)
      ret << u.safe_output_with_relation(session_uid).merge!({time:Checkin.time_desc(cat)})
    end
    ret
  end
  
  def sub_shops
    return [] if shops.nil?
    return shops.map {|x| Shop.find_by_id(x)}.reject {|x| x.nil?}
  end


  
  def send_coupon(user_id)
    coupons = []
    Coupon.gen_demo(self.id) if self.latest_coupons.empty? && (ENV["RAILS_ENV"] != "production" || user_id.to_s =="502e6303421aa918ba000001" || user_id.to_s =="502e6303421aa918ba000006")
    coupons += self.latest_coupons.select { |c| c.allow_send?(user_id) }    
    sub_shops.each do |shop|
      coupons += shop.latest_coupons.select { |coupon| coupon.allow_send?(user_id) }
    end

    coupons.each{|coupon| coupon.send_coupon(user_id)}
    #    find coupons
    #    send
   
    return if coupons.count == 0
    name = coupons.map { |coupon| coupon.name  }.join(',').truncate(50)
    xmpp2 = Xmpp.gchat(self.id.to_i,user_id,"收到#{coupons.count}张优惠券: #{name}")
    return xmpp2 if ENV["RAILS_ENV"] != "production"
    logger.info(xmpp2)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2) 
  end

  
  def latest_coupons(n=1)
    coupons = Coupon.where({shop_id: self.id}).sort({_id: -1}).limit(n).to_a
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
    Mongoid.session(:dooo).command(eval:"baidu_to_real(#{lob})")["retval"]
  end
  
  def lob_to_lo
    Shop.lob_to_lo self.lob
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

  
end
