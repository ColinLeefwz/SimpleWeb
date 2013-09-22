# coding: utf-8
class ShopFaq
  include Mongoid::Document

  field :sid, type: Integer
  field :od #数字排序
  field :title #问题
  
  field :text #简单回答，或者摘要
  field :img #回答的图片
  
  field :url #回答点开的链接
  
  field :head #回答点开的内容头部
  field :content #回答点开的内容

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
  
  def output
    if img.blank?
      text
    else
      "[img:faq#{_id}]#{text}"
    end
  end
  
  
  def self.init_city_faq_redis
    ShopFaq.all.each {|x| $redis.sadd("FaqS#{x.shop.city}", x.sid)}
  end

end
