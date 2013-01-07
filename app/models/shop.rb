# coding: utf-8

#<20275139,百度数据
#20275139~20347004, mapabc数据
#>20347004 osm数据
#>21000000 手动数据

class Shop
  include Gps
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

  #field :cc, type:Integer  #点评的评论数
  field :type              #从mapabc导入的商家类型

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
  
  
  
  def find_shops(loc,accuracy,ip,uid,debug=false)
    radius = 0.0018+0.002*accuracy/300
    radius=0.01 if(radius>0.01)  #不大于1000米
    arr = Shop.collection.find({lo:{"$near" =>loc,"$maxDistance"=>radius}}).limit(100).to_a
    arr.uniq_by! {|x| x["_id"]}
    if arr.length>=3
      return sort_with_score(arr,loc,accuracy,ip,uid,debug)
    else
      arr = Shop.collection.find({lo:{"$near" =>loc}}).limit(10).to_a
      arr.uniq_by! {|x| x["_id"]}
      return sort_with_score(arr,loc,accuracy,ip,uid,debug)[0,5]
    end
  end
  
  def sort_with_score(arr,loc,accuracy,ip,uid,debug=false)
    score = arr.map {|x| [x,min_distance(x,loc),0]}
    min_d = score[0][1]
    score.reject!{|s| (s[0]["t"]==0 && s[0]["del"]) } #过期的活动
    if score.length>5
      score.reject!{|s| (s[0]["del"] && s[1]>30 ) }
    end
    if score.length>5
      score.reject!{|s| (s[0]["d"] && s[1]>(100-s[0]["d"]) ) }
    end
    score.reject!{|s| s[0]["del"] } if score.length>10
    score.reject!{|s| s[0]["d"] && s[0]["d"]>=30 } if score.length>20
    score.reject!{|s| s[0]["d"] } if score.length>25
    if score.length>5
      score = score[0,5]+score[5..-1].reject{|s| (s[0]["d"] || s[0]["t"].nil?)}
    end
    score.each do |xx|
      x=xx[0]
      base_score(xx,x)
      shop_history_score(xx,x,ip,"ObjectId(\"#{uid}\")")
    end
    realtime_score(score)
    score.each_with_index do |xx,i|
      xx[2] =  adjust(xx[2],accuracy,min_d)
      xx[1] += xx[2]
    end
    score.sort! {|a,b| a[1]<=>b[1]}
    ret = []
    score.each_with_index do |x,i|
      if i<5
        ret << x
      else
        ret << x if x[0]["t"]
      end
    end
    if debug
      return ret
    else
      return ret[0,30].map {|x| x[0]}
    end
  end
  
  def adjust(score,accuracy,min_d)
    ret = score
    ret = -200 if ret < -200 #最多加权2/3后封顶
    acc = accuracy
    acc = 30 if acc<30
    acc = 1000 if acc>1000
    ret = ret*(acc/300.0)
    return ret if min_d<acc #如果最近的点在误差范围之内
    factor = (min_d-acc)/30.0
    factor = 3 if factor>3
    return ret*(1+factor)
  end
  
  def realtime_score(score)
    shop_ids = score.map{|x| x[0]["_id"].to_i}
    Checkin.get_users_count_multi(shop_ids).map{|x| user_to_score(x)}.each_with_index do |s,i|
      score[i][2] -= s 
    end
  end
  
  def shop_history_score(xx,x,ip,uid_s)
      sc = CheckinShopStat.find_by_id(x["_id"].to_i)
      return if sc.nil?
      if uid_s && sc.users[uid_s]
        ucount = sc.users[uid_s][0]
        xx[2] -= ucount*30
        xx[2] -= user_to_score(sc.users.length)/2.0
      end
      if ip && ip.index(",").nil?
        ip2 = ip.split(".").join("/")
        ip2s = sc.ips[ip2]
        if(ip2s)
          ipcount = sc.ips[ip2][0]
          xx[2] -= ipcount*5
        end
      end
  end
  
  def base_score(xx,x)
    today = Time.now
    hour = today.hour
    hminute = hour*60+today.min
    t = x["t"]
    stype = x["type"]
    stype='' if(!stype)
    if t
      t = t.to_i
      xx[2]-=10 if t<4
      xx[2]-=20 if t==0
      xx[2]-=5 if t>=4 && t<50
      xx[2]+=30 if t==14 # 14:大型医院
    else
      xx[2] +=10
    end
    if x["shops"]
      xx[2]-=30
      xx[2]-=x["shops"].length
    end
    xx[2]-=10 if x["lo"][0].class==Array
    xx[2]+= x["d"] if x["d"]
    xx[2]+=150 if x["del"]
    if t==1
      xx[2]-=30 if (hour>=20 || hour <=3)
      xx[2]+=20 if (hour>=6 || hour <=12)
    end
    if (t==4)
      if(hour>=11 && hour<=13) 
        xx[2]-=20 
      elsif (hour>=17 && hour<=19)
        xx[2]-=20
      elsif (hminute>(14*60+30) && hminute<(16*60+30) )
        xx[2]+=10
      end
    end
    if t==11
      xx[2] -=10 if(hour>=20 || hour<=8)
    end
    if t==10
      if(today.wday>=1 && today.wday<=5)
        xx[2] -=10 if(hour>=14 && hour<=17)
        xx[2] -=10 if(hour>=8 && hour<=11)
        xx[2] +=10 if(hour>=19)
      else
        xx[2] +=10;
      end
    end
    len = x["name"].length
    xx[2] += (10+(len-11)*3) if len>11
    xx[2] += (10+(4-len)*3) if len<4
  end
  
  def user_to_score(uc)
    return uc*3 if(uc<=10) 
    return 75 if(uc>100) 
    return 30+(uc-10)/2
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
  
  def self.next_id
    Shop.all.sort({_id: -1}).limit(1).to_a[0].id.to_i+1
  end
  
  #将子商家的经纬度合并到主商家中
  def merge_subshops_locations
    arr = merge_locations(sub_shops)
    self.update_attributes!({lo:arr})
  end

  
end
