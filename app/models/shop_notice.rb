class ShopNotice
  include Mongoid::Document

  field :_id, type: Integer
  field :title
  field :photo_id, type: Moped::BSON::ObjectId #从商家图片中选择一张做公告
  field :faq_id, type: Moped::BSON::ObjectId #从商家问题中选择一个做公告

  index({ shop_id: 1})


  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :desc, :to => :photo
  end

  def shop
    Shop.find_by_id(_id)
  end

  def self.find_or_new(id)
    sn = self.find_by_id(id)
    if sn.nil?
      sn = self.new
      sn.id = id
    end
    sn.unset(:title)
    sn.unset(:photo_id)
    sn.unset(:faq_id)
    sn
  end

  def text?
    !self.title.blank?
  end

  def photo
    Photo.find_by_id(photo_id)
  end

  def faq
    ShopFaq.find_by_id(faq_id)
  end

  def delete
    Rails.cache.delete("ShopNotice#{self.id.to_s}")
    super
  end
  
end
