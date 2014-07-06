class ShopCase
  include Mongoid::Document

  field :sid, type: Integer
  field :type
  field :title
  field :content

  
  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :to => :shop
  end


  def shop
    Shop.find_by_id(self.sid)
  end

  
end
