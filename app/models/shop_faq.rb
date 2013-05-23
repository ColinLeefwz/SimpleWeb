# coding: utf-8
class ShopFaq
  include Mongoid::Document

  field :sid, type: Integer
  field :title
  field :text
  field :img
  field :od

  validate do |faq|
    errors.add(:od, "序号不能是空.") if faq.od.blank?
    errors.add(:title, "标题不能是空.") if faq.title.blank?
    errors.add(:img, "文本和图片至少有一个存在.") if faq.text.blank? && faq.img.blank?
  end

  mount_uploader(:img, FaqImgUploader)
  
  index({sid: 1, od:1})
  
  
  def self.img_url(id,type=nil)
    if type
      "http://oss.aliyuncs.com/dface/#{id}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/dface/#{id}/0.jpg"
    end
  end
  

  def shop
    Shop.find_by_id(sid)
  end
  
  def self.init_city_faq_redis
    ShopFaq.all.each {|x| $redis.sadd("FaqS#{x.shop.city}", x.sid)}
  end

end
