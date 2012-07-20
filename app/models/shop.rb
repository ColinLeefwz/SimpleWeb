class Shop
  include Mongoid::Document
  field :id, type: Integer
  field :name
  field :loc, type:Array
  field :phone
  field :city, type: Integer
  field :cc, type:Integer
  field :man, type:Boolean
  
  
  
  def safe_output
    self.attributes.slice("id", "name", "address" , "phone").merge!( {"lat"=>self.loc[0], "lng"=>self.loc[1]} )
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
