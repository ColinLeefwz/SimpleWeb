# coding: utf-8
class ShopFaq
  include Mongoid::Document

  field :sid, type: Integer
  field :title
  field :text
  field :img
  field :od

  validates_presence_of :od, :message => '序号不能是空.'
  validates_presence_of :title, :message => '标题不能是空.'
  validates_presence_of :img, :message => "文本和图片至少有一个存在.", :if => "text.blank?"

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

end
