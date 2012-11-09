# coding: utf-8
class Shop
  include Mongoid::Document
  #store_in collection: "baidu"
  field :_id, type: Integer
  field :pass
  field :name
  #field :lob, type:Array #百度地图上的经纬度  
  #field :loc, type:Array #google地图上的经纬度
  field :lo, type:Array #实际的经纬度
  field :tel 
  field :city
  field :del,type:Integer   #删除标记, 如果被删除del=1，否则del不存在. 
  field :addr
  field :t                #脸脸的商家类型
  field :password
  field :utotal, type:Integer, default:0 #截至到昨天，该商家的用户总数
  field :uftotal, type:Integer, default:0 #截至到昨天，该商家的女性用户总数
  field :shops, type:Array #子商家

  #field :cc, type:Integer  #点评的评论数
  #field :type              #从mapabc导入的商家类型

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
  
  def self.import_form(mshop) #从Mshop导入点评商家
    begin
      city = Mcity.find(mshop.mcity_id).code
    rescue  Exception => error
    end
    city = "0571" if city.nil?
    id = Shop.count+1
    lo = Mongoid.default_session.command(eval:"gcj02_to_real([#{mshop.lat}, #{mshop.lng}])")["retval"]
    hash = {
      _id: id,
      city: city,
      name: mshop.name,
      addr: mshop.address,
      tel: mshop.phone,
      loc: [mshop.lat.to_f,mshop.lng.to_f],
      lo: lo,
      cc: mshop.comment_count
    }
    #TODO: 点评的商家类型映射到脸脸的商家类型
    Shop.collection.insert hash
  end

  #删除商家.
  def shop_del
    self.update_attribute(:del,1)
  end
  
  def loc_first
    if self["loc"][0].class==Array
      self["loc"][0]
    else
      self["loc"]
    end
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
    {1 => '酒吧• 活动', 2 => '咖啡• 茶馆', 3 => '餐饮• 酒店', 4 => '休闲• 娱乐', 5 => '购物• 广场', 6 => "'楼宇• 社区'"}[self.t.to_i]
  end

  def logo
    ShopLogo.shop_logo(id)
  end

  def staffs
    Staff.where({shop_id: self.id}).map {|x| x.user_id}
  end

  def notice
    ShopNotice.where({shop_id: self.id, effect: true}).inject("") {|mem,x| mem << x.title }
  end

  #从CheckinShopStat获得昨天以前的用户签到记录，从redis中获得今天的用户签到记录，然后合并
  def user_last_checkins
    users1 = Checkin.get_users_redis(id.to_i)
    uids = users1.map {|arr| arr[0]}
    css = CheckinShopStat.find_by_id(id.to_i)
    return users1 if css.nil?
    users2 = css.users.map {|k,v| [k[10..-3],v[1].generation_time.to_i]} # ObjectId("k") => k
    users2.sort!{|a,b| b[1] <=> a[1]}
    users2.each {|arr| users1 << arr unless uids.member?(arr[0])}
    users1
  end

  def users(session_uid,start,size)
    #TODO: 性能优化，目前当用户大于10个时，执行耗时在半秒以上。
    #Benchmark.measure {Shop.find(4928288).users(User.last._id)} 
    ret = []
    user_last_checkins[start,size].each do |uid,cat|
      u = User.find2(uid)
      next if u.block?(session_uid)
      ret << u.safe_output_with_relation(session_uid).merge!({time:Checkin.time_desc(cat)})
    end
    ret
  end


  
  def send_coupon(user_id)
    coupons = []
    Coupon.gen_demo(self.id) if self.latest_coupons.empty?
    coupons += self.latest_coupons.select { |coupon| coupon.allow_send?(user_id) }
    self.shops.each do |sid|
      shop = Shop.find(sid)
      coupons += shop.latest_coupons.select { |coupon| coupon.allow_send?(user_id) }
    end

    coupons.each{|coupon| coupon.send_coupon(user_id)}
    #    find coupons
    #    send
    return "收到#{coupons.count}张优惠券" if ENV["RAILS_ENV"] != "production"
    return if coupons.count == 0
    xmpp2 = "<message to='#{user_id}@dface.cn' from='#{shop_id}@c.dface.cn' type='groupchat'><body>收到#{coupons.count}张优惠券</body></message>"
    logger.info(xmpp2)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2) 
  end

  
  def latest_coupons(n=1)
    coupons = Coupon.where({shop_id: self.id}).sort({_id: -1}).limit(n).to_a
  end

end
