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
  field :del,type:Integer   #删除标记, 如果被删除del=1，否则del不存在. db.shops.ensureIndex({del:1},{sparse:true})
  field :addr
  field :t                #脸脸的商家类型
#  field :level            #商家的人工等级
  field :password
  field :utotal, type:Integer, default:0 #截至到昨天，该商家的用户总数
  field :uftotal, type:Integer, default:0 #截至到昨天，该商家的女性用户总数

  #field :cc, type:Integer  #点评的评论数
  #field :type              #从mapabc导入的商家类型

  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6, :allow_nil => true

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
    male = self.utotal - self.uftotal
    safe_output.merge!( {"user"=>utotal, "male"=>male, "female"=>uftotal} )
  end

  
  def show_t
    {1 => '酒吧• 活动', 2 => '咖啡• 茶馆', 3 => '餐饮• 酒店', 4 => '休闲• 娱乐', 5 => '购物• 广场', 6 => "'楼宇• 社区'"}[self.t.to_i]
  end

  def logo
    ShopLogo.shop_logo(id)
  end

  #从CheckinShopStat获得昨天以前的用户签到记录，从redis中获得今天的用户签到记录，然后合并
  def user_last_checkins
    users1 = Checkin.get_users_redis(id.to_i)
    uids = users1.map {|arr| arr[0]}
    users2 = CheckinShopStat.find(id.to_i).users.map {|k,v| [k[10..-3],v[1].generation_time.to_i]} # ObjectId("k") => k
    users2.sort!{|a,b| b[1] <=> a[1]}
    users2.each {|arr| users1 << arr if uids.member?(arr[0])}
    users1
  end

  def users(session_uid)
    ret = []
    user_last_checkins.each do |uid,cat|
      u = User.find2(uid)
      next if u.block?(session_uid)
      ret << u.safe_output_with_relation(session_uid).merge!({time:Checkin.time_desc(cat)})
    end
    ret
  end

end
