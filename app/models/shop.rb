# coding: utf-8

#<20275139,百度数据
#20275139~20347004, mapabc数据
#>20347004 osm数据
#>21000000 手动数据

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
  field :phone
  field :lob, type:Array
  field :del,type:Integer   #删除标记, 如果被删除del=1，否则del不存在. 
  field :addr
  field :t                #脸脸的商家类型
  field :password
  field :utotal, type:Integer, default:0 #截至到昨天，该商家的用户总数
  field :uftotal, type:Integer, default:0 #截至到昨天，该商家的女性用户总数
  field :shops, type:Array #子商家
  #field :osm_id #Open Street Map node id

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

  #删除商家.
  def shop_del
    self.update_attribute(:del,1)
  end
  
  def loc_first
    return lo
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
  
  def sub_shops
    return [] if shops.nil?
    return shops.map {|x| Shop.find(x)}
  end


  
  def send_coupon(user_id)
    coupons = []
    Coupon.gen_demo(self.id) if self.latest_coupons.empty? && ENV["RAILS_ENV"] != "production"
    coupons += self.latest_coupons.select { |coupon| coupon.allow_send?(user_id) }
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
  
  
  
  def find_shops(loc,accuracy,ip,uid)
    radius = 0.0015+0.002*accuracy/300
    radius=0.01 if(radius>0.01)  #不大于1000米
    arr = Shop.collection.find({lo:{"$near" =>loc,"$maxDistance"=>radius}}).limit(100).to_a
    arr.uniq_by! {|x| x["_id"]}
    if arr.length>=3
      return sort_with_score(arr,loc,accuracy,ip,uid)
    else
      arr = Shop.collection.find({lo:{"$near" =>loc}}).limit(3).to_a
      arr.uniq_by! {|x| x["_id"]}
      return arr
    end
  end
  
  def sort_with_score(arr,loc,accuracy,ip,uid)
    score = arr.map {|x| [x,min_distance(x,loc),0]}
    score.each do |xx|
      x=xx[0]
      base_score(xx,x)
      shop_history_score(xx,x,ip,uid)
    end
    realtime_score(score)
    score.each_with_index do |xx,i|
      xx[2]=-200 if(xx[2] < -200)  #最多加权2/3后封顶
      xx[1] += (xx[2]*accuracy/300)
    end
    score.sort! {|a,b| a[1]<=>b[1]}
    return score[0,30].map {|x| x[0]}
  end
  
  def realtime_score(score)
    shop_ids = score.map{|x| x[0]["_id"].to_i}
    Checkin.get_users_count_multi(shop_ids).map{|x| user_to_score(x)}.each_with_index do |s,i|
      score[i][2] -= s 
    end
  end
  
  def shop_history_score(xx,x,ip,uid)
    begin
      sc = CheckinShopStat.find(x["_id"].to_i)
      if uid && sc.users[uid]
        ucount = sc.users[uid][0];
        xx[2] -= ucount*30;
      end
      if ip.index(",")==-1
        ip2 = ip.replace('.', '/', 'g');
        ip2s = sc.ips[ip2];
        if(ip2s)
          ipcount = sc.ips[ip2][0];
          xx[2] -= ipcount*5;
        end
      end
    rescue
    end
  end
  
  def base_score(xx,x)
    today = Time.now
    hour = today.hour
    hminute = hour*60+today.min
    t = x["t"]
    stype = x["type"]
    stype='' if(!stype)
    xx[2]-=5 if t
    xx[2]+=30 if x["del"]
    xx[2]-=30 if t==1 && (hour>=20 || hour <=3)
    if (t==3 && stype.index('餐饮')==0)
      if(hour>=11 && hour<=13) 
        xx[2]-=20 
      elsif (hour>=17 && hour<=19)
        xx[2]-=20
      elsif (hminute>(14*60+30) && hminute<(16*60+30) )
        xx[2]+=30
      end
    end
    if t==6
      if(stype.index('商务住宅')==0)
        if(stype.index('商务住宅;住宅区')==0)
          xx[2] -=10 if(hour>=20 || hour<=8)
        else
          if(today.wday>=1 && today.wday<=5)
            xx[2] -=10 if(hour>=14 && hour<=17)
            xx[2] -=10 if(hour>=8 && hour<=11)
            xx[2] +=20 if(hour>=19)
          else
            xx[2] +=20;
          end
        end
      end
    end
  end
  
  def user_to_score(uc)
    return uc*3 if(uc<=10) 
    return 75 if(uc>100) 
    return 30+(uc-10)/2
  end
  
  
  def num_to_rad(d)
    return d * 3.1416 / 180.0
  end
  
  def pow(x,y)
    x ** y
  end
  
  def get_distance4( lat1,  lng1,  lat2,  lng2)
    radLat1 = num_to_rad(lat1)
    radLat2 = num_to_rad(lat2)
    a = radLat1 - radLat2
    b = num_to_rad(lng1) - num_to_rad(lng2)
    s = 2 * Math.asin(Math.sqrt(pow(Math.sin(a/2),2) +
          Math.cos(radLat1)*Math.cos(radLat2)*pow(Math.sin(b/2),2)))
    s = s *6378.137  #EARTH_RADIUS;
    s = (s * 10000).round / 10
    return s
  end
  
  def get_distance( loc1,loc2)
    return get_distance4(loc1[0],loc1[1],loc2[0],loc2[1])
  end
  
  def min_distance(shop,loc)
    if(shop["lo"][0].class==Array)
      shop["lo"].map {|x| get_distance(x,loc)}.min
    else
      return get_distance(shop["lo"],loc)
    end

  end

  
end
