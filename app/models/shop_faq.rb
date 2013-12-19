# coding: utf-8
class ShopFaq
  include Mongoid::Document

  field :sid, type: Integer
  field :od #数字排序
  field :title #问题
  
  field :text #简单回答，或者摘要
  field :img #回答的图片
  
  field :link_rule

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

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :notice, :to => :shop
  end
  
  
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
  
  def attr_ext
    attrs = " NOLOG='1' "
    ext = nil
    if self.url && self.link_rule == '0'
      attrs += " url='#{self.url}' " 
      ext = "<x xmlns='dface.url'>#{self.url}</x>"
    end
    if self.content && self.link_rule == '1'
      purl = "http://shop.dface.cn/shop3_faqs/show?id=#{self.id}"
      attrs += " url='#{purl}' "
      ext = "<x xmlns='dface.url'>#{purl}</x>"
    end
    [attrs,ext]
  end
  
  def send_to_room(uid, sid=nil)
    sid = self.sid if sid.nil?
    attrs, ext = self.attr_ext
    text = self.output
    Xmpp.send_gchat2($gfuid,sid,uid, text, "FAQ#{sid}#{uid}#{Time.now.to_i}", attrs, ext)
    zwyd_delay_send(uid, sid) if sid.to_s =='21828958' && self.od.to_s == '02'
  end

  #紫薇原点延迟发送
  def zwyd_delay_send(uid,sid)
    url = "dface://scheme/getphoto"
    attrs = " NOLOG='1'  url='#{url}' "
    ext = "<x xmlns='dface.url'>#{url}</x>"
    Resque.enqueue_in(5.seconds,XmppRoomMsg, $gfuid,sid,uid,'点击此处马上参与活动',nil, attrs="", ext="") 
  end
  
  def send_to_user(uid)
    attrs, ext = self.attr_ext
    text = self.output
    Xmpp.send_chat($gfuid,uid, text, "FAQ#{sid}#{uid}#{Time.now.to_i}", attrs, ext)
  end
  
  
  def self.init_city_faq_redis
    ShopFaq.all.each {|x| $redis.sadd("FaqS#{x.shop.city}", x.sid)}
  end

  #调用新浪接口 把长链转成短链
  def self.short_url(token, long_url,err_num=0)
    return long_url if err_num >= 3
    lurl = URI.encode_www_form_component(long_url)
    url = "https://api.weibo.com/2/short_url/shorten.json?access_token=#{token}&url_long=#{lurl}"
    begin
      response = JSON.parse(RestClient.get(url))
      response['urls'][0]['url_short']
    rescue RestClient::BadRequest
      return long_url
    rescue
      return short_url(token, long_url,(err_num + 1))
    end
  end


  #faq设为公告时， 对公告的block操作
  def crud_notice(&block)
    notice = self.shop_notice
    if notice && self.id == notice.faq_id
      block.call(notice)
    end
  end


end
