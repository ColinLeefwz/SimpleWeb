class ShopTopNotice
  include Mongoid::Document
  
  field :shop_id, type: Integer
  field :title
  #  field :begin, type:DateTime
  #  field :end, type:DateTime
  #  field :ord, type:Float
  #  field :effect, type:Boolean,default:true

  index({ shop_id: 1})

  def shop
    Shop.find_by_id(shop_id)
  end

  def self.find_or_new(id)
    begin
      self.find(id)
    rescue
      self.new
    end
  end
  
end
