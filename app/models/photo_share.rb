# coding: utf-8

class PhotoShare
  include Mongoid::Document
  field :uid, type: Moped::BSON::ObjectId
  field :pid
  field :weibo, type:Boolean #是否分享到新浪微博
  field :qq, type:Boolean  #是否分享到QQ空间
  field :wx, type:Integer   #分享到微信: 1个人,2朋友圈, 3都分享了

  #  attr_accessor :shared   # 被分享的对象

  def faqs_output
    $mansion3.map do |ma|
      ShopFaq.where({sid:ma,od:"03"}).first.id
    end
  end

  after_create :async_send

  def async_send
    c = ["52fd7ed120f318afde000012","52f97dce7ec458d4c1c9c62f", "52f99ab77ec458d4c1c9ca7c", "52f97dce7ec458d4c1c9c605", "52f97dce7ec458d4c1c9c617", "52f97dce7ec458d4c1c9c61d", "52f97dce7ec458d4c1c9c623", "52f97dce7ec458d4c1c9c635", "52f97dce7ec458d4c1c9c63b", "52f97dce7ec458d4c1c9c641", "52f97dce7ec458d4c1c9c647", "52f9a23c7ec458d4c1c9cc79", "52f9a23c7ec458d4c1c9cc7f", "52f9a23c7ec458d4c1c9cc85", "52f9b06d20f31803a900001b", "52f97dce7ec458d4c1c9c64d", "52f9a23d7ec458d4c1c9cc91", "52f9a23d7ec458d4c1c9cc97", "52f9a23d7ec458d4c1c9cc9d", "52f9a23d7ec458d4c1c9cca3", "52f9a23d7ec458d4c1c9cd03", "52f9a23d7ec458d4c1c9ccaf", "52f9a23d7ec458d4c1c9ccb5", "52f9a23d7ec458d4c1c9ccc1", "52f9a23d7ec458d4c1c9cd15", "52f9a23d7ec458d4c1c9cccd", "52f9a23d7ec458d4c1c9ccd3", "52f9a23d7ec458d4c1c9ccd9", "52f9a23d7ec458d4c1c9ccdf", "52f9a23d7ec458d4c1c9cce5", "52f9a23d7ec458d4c1c9cceb", "52f9a23d7ec458d4c1c9ccf1", "52f9a23d7ec458d4c1c9ccf7", "52f9a23d7ec458d4c1c9ccfd", "52f9a23d7ec458d4c1c9cd03", "52f9a23d7ec458d4c1c9cd09", "52f9a23d7ec458d4c1c9cd0f", "52f9a23d7ec458d4c1c9cd15", "52f9a23e7ec458d4c1c9cd1b", "52f9a23e7ec458d4c1c9cd21", "52f9a23e7ec458d4c1c9cd27", "52f9a23e7ec458d4c1c9cd2d", "52f9a23e7ec458d4c1c9cd33", "52f9a23e7ec458d4c1c9cd39", "52f9a23e7ec458d4c1c9cd3f", "52f9ca347ec458d4c1c9d25a", "52f9a23e7ec458d4c1c9cd4b", "52f9a23e7ec458d4c1c9cd51", "52f9a23e7ec458d4c1c9cd57", "52f9a23e7ec458d4c1c9cd5d", "52f9a23e7ec458d4c1c9cd63", "52f9a23e7ec458d4c1c9cd69", "52f9a23e7ec458d4c1c9cd6f", "52f9a23e7ec458d4c1c9cd75", "52f9a23e7ec458d4c1c9cd7b", "52fc2f0420f318429c000005", "52fc302720f318e38700000d"]
    shared = parse_pid
    return if shared.nil?
    send_wb(shared) if weibo
    send_qq(shared) if qq
    if weibo || qq || (wx && wx>0)
      send_coupon(shared)
    end
    if pid.match(/^faq/)
      test = ShopFaq.find_by_id(pid.sub(/faq/, ''))
      if c.include?test.id.to_s
        send_coupon2(test)
      end
    end
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
    cp = Coupon.find_by_id("52fad3c420f318a845000017")
    cp.send_coupon(self.uid)
  end

end

