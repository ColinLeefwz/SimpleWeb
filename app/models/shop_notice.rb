class ShopNotice
  include Mongoid::Document
  
  field :shop_id, type:Integer
  field :title
  #  field :begin, type:DateTime
  #  field :end, type:DateTime
  field :ord, type:Float
  field :effect, type:Boolean,default:true

  index({ shop_id: 1})


  #从新排序
  def reord
    sns = ShopNotice.where({shop_id: self.shop_id, effect: true, _id: {"$ne" => self._id}, ord: {"$gte" => self.ord}})
    sns.each do |sn|
      sn.update_attribute(:ord, sn.ord+1)
    end
  end

  #显示公告的个数
  def self.show_notices(shop_id,limit)
    self.where({shop_id: shop_id.to_s, effect: true, ord: {"$ne" => nil}}).sort({ord: 1}).limit(limit)
  end

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
