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
  field :level            #商家的人工等级
  field :password

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
    a,b,c = users_count
    safe_output.merge!( {"user"=>a, "male"=>b, "female"=>c} )
  end
  
  def users_count
    str="shop_user_count(#{self.id})"
    Mongoid.default_session.command(eval:str)["retval"].map {|x| x.to_i}
  end
  
end
