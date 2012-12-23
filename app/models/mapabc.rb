class Mapabc
  include Mongoid::Document
  store_in({:collection =>  "mapabc", :session => "dooo"})
  field :name
  field :loc, type:Array
  field :phone
  field :city
  field :addr
  field :type
  
  
  
  def safe_output
    if self.loc[0].class==Array #一个地点多个经纬度
      self.attributes.slice("name", "phone").merge!( {"lat"=>self.loc[0][0], "lng"=>self.loc[0][1], "address"=>self.addr, "id" => self.id} )
    else
      self.attributes.slice("id", "name", "phone").merge!( {"lat"=>self.loc[0], "lng"=>self.loc[1], "address"=>self.addr, "id" => self.id} )
    end
  end
  
  def safe_output_with_users
    a,b,c = users_count
    safe_output.merge!( {"user"=>a, "male"=>b, "female"=>c} )
  end
  
  def users_count
    us = users.size
    female = users.where("gender=2").size
    [us,us-female,female]
  end
  
  def users
    User.where("name is not null and id<60").order("id asc")
  end
  
  
end
