# coding: utf-8

class CouponDown
  include Mongoid::Document

  field :cid, type: Moped::BSON::ObjectId #优惠券
  field :sid, type: Integer #商家
  field :uid, type: Moped::BSON::ObjectId #用户
  field :dat, type: DateTime  #下载时间
  field :sat, type: DateTime #收到时间
  field :vat, type: DateTime #查看时间
  field :uat, type: DateTime  #使用时间
  field :photo_id, type: Moped::BSON::ObjectId # 分享类优惠券的分享图片id
  field :sub_sid, type: Integer #获得主店分享类优惠券时，实际分享发生的分店id
  field :data #消费时输入的数据，可以是消费金额／手机号码／服务员编号等

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :gender, :birthday, :weibo_home, :to => :user
    option.delegate :name, :to => :shop
    option.delegate :img, :name, :show_t2,  :to => :coupon
  end

  index({cid: 1, uid:1})
  
  def shop
    Shop.find_by_id(sid)
  end

  def user
    User.find_by_id(uid)
  end
  
  def coupon
    Coupon.find_by_id(cid)
  end
  
  def photo
    Photo.find_by_id(photo_id)
  end
   
  def message
    s = "[优惠券:#{coupon.name}:#{shop.name}:#{id}:#{dat.strftime('%Y-%m-%d %H：%M')}"
    s += ":#{coupon.hint}" if coupon.hint
    s += "]"
    s
  end
  
  def self.download(coupon, user_id, photo_id=nil, sid = nil)
    cpdown = CouponDown.new
    cpdown.cid = coupon.id
    cpdown.sid = coupon.shop_id
    cpdown.uid = user_id
    cpdown.dat = Time.now
    cpdown.photo_id = photo_id if photo_id
    cpdown.sub_sid = sid if sid
    cpdown.save!
    cpdown.gen_share_coupon_img if photo_id
    cpdown
  end
  
  def use(user_id, data)
    raise "你没有获取这张优惠券" if self.uid!=user_id
    self.uat = Time.now
    self.data = data if data
    self.save!
  end
  
  def gen_share_coupon_img
    raise "图片分享后才能生成分享类优惠券" unless photo_id
    path = share_coupon_img_path
    return path if File.exist?("public"+path)
    `cd coupon && ./gen_demo.sh '#{coupon.name}' '#{coupon.desc}' ../public#{path} #{Photo.img_url(photo_id, :t2)}`
    return path
  end
  
  def share_coupon_img_path
    "/uploads/tmp/cpd_#{self.id}.jpg"
  end
  
end