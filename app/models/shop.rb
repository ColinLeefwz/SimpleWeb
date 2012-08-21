class Shop
  include Mongoid::Document
  field :_id, type: Integer
  field :name
  field :loc, type:Array #地图上的经纬度
  field :lo, type:Array #实际的经纬度
  field :tel
  field :city
  field :addr
  field :t                #脸脸的商家类型
  field :level            #商家的人工等级
  #field :cc, type:Integer  #点评的评论数
  #field :type              #从mapabc导入的商家类型
  
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
  
  def loc_first
    if self["loc"][0].class==Array
        self["loc"][0]
    else
        self["loc"]
    end
  end
  
  def safe_output
    self.attributes.slice("name", "phone", "lo", "t").merge!( {"lat"=>self.loc_first[0], "lng"=>self.loc_first[1], "address"=>self.addr, "id"=>self.id} )
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
