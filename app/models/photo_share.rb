# coding: utf-8

class PhotoShare
  include Mongoid::Document
  field :uid, type: Moped::BSON::ObjectId
  field :pid
  field :weibo, type:Boolean #是否分享到新浪微博
  field :qq, type:Boolean  #是否分享到QQ空间
  field :wx, type:Integer   #分享到微信: 1个人,2朋友圈, 3都分享了

  #  attr_accessor :shared   # 被分享的对象
  after_create :async_send

  def async_send
    shared = parse_pid
    return if shared.nil?
    send_wb(shared) if weibo
    send_qq(shared) if qq
    if weibo || qq || (wx && wx>0)
      send_coupon(shared)
    end
    test = ShopFaq.find_by_id("faq52f9b06d20f31803a900001b".sub(/faq/, ''))
    send_coupon2(test)
  end

  #被分享的对象
  def parse_pid
    if pid.match(/^faq/)
      ShopFaq.find_by_id(pid.sub(/faq/, ''))
    else
      Photo.find_by_id(pid)
    end
  end

  def user
    User.find_by_id(self.uid)
  end

  def send_wb(shared)
    str = "我刚刚用\#脸脸\##{shared.shop.name}分享了一张图片(来自脸脸: http://www.dface.cn/a?v=3 )"
    Resque.enqueue(WeiboPhoto, $redis.get("wbtoken#{uid}"), str, shared.img.url)
  end

  def share_url
    "http://www.dface.cn/web_photo/show?id=#{self.id}"
  end

  def send_qq(shared,direct=false)
    title = "我在\##{shared.shop.name}"
    text = "刚刚用脸脸分享了一张图片。(脸脸下载地址: http://www.dface.cn/a?v=18 )"
    str = "我刚刚用\#脸脸\##{shared.shop.name}分享了一张图片"
    img_url = shared.img.url(:t2)
    if direct
      QqPhoto.perform(uid, title, text, share_url, str, img_url)
    else
      Resque.enqueue(QqPhoto, uid, title, text,share_url, str, img_url)
    end
  end

  def send_coupon(shared)
    return if shared.nil?
    return if (shop = shared.shop).nil?
    coupon = shop.share_coupon(1)
    return coupon if coupon.nil?
    if coupon.faq_id == shared.id && coupon.allow_send_share?(uid.to_s)
      coupon.send_coupon(uid,'',shop.id)
      message = "恭喜#{user.name}！收到一张分享优惠券: #{coupon.name},马上领取吧！"
      return message if ENV["RAILS_ENV"] != "production"
      Resque.enqueue(XmppNotice, shop.id,uid, message,"coupon#{Time.now.to_i}","url='dface://record/coupon?forward'")
    end
    nil
  end

  def send_coupon2(test)
    return if test.nil?
    cp = Coupon.find_by_id("52f9da8820f318beca000002")
    cp.send_coupon("51910153c90d8b1e2000015e",'',"20325453")
  end

end

