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
  field :num, type:Integer #优惠券下载编号， 每个优惠券独立编号

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :gender, :birthday, :weibo_home,:show_gender, :to => :user
    option.delegate :name, :city, :to => :shop
    option.delegate :name, :to => :sub_shop
    option.delegate :img, :name, :show_t2, :desc,  :to => :coupon
  end

  index({cid: 1, uid:1})
  index({dat: -1})
  
  def shop
    @_shop ||= Shop.find_by_id(sid)
  end

  def sub_shop
    Shop.find_by_id(sub_sid)
  end

  def user
    @_user ||= User.find_by_id(uid)
  end
  
  def coupon
    @_coupon ||= Coupon.find_by_id(cid)
  end
  
  def photo
    Photo.find_by_id(photo_id)
  end
   
  def message
    date = (dat.to_time+3600*8).strftime('%Y-%m-%d %H：%M')
    s = "[优惠券:#{coupon.name}:#{shop.name}:#{id}:#{date}"
    s += ":#{coupon.hint}" if coupon.hint
    s += "]"
    s
  end

  def self.next_num(cid)
    $redis.incr("CPD#{cid}")
    #cpdown = self.where({cid: cid}).sort({num: -1}).limit(1).first
    #(cpdown && cpdown.num) ? cpdown.num.succ : 1
  end
  
  def self.download(coupon, user_id, photo_id=nil, sid = nil)
    cpdown = CouponDown.new
    cpdown.cid = coupon.id
    cpdown.sid = coupon.shop_id
    cpdown.uid = user_id
    cpdown.dat = Time.now
    cpdown.photo_id = photo_id if photo_id
    cpdown.sub_sid = sid if sid
    cpdown.num = next_num(coupon.id)
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
    desc = coupon.desc.to_s
    dea = desc.split(/\r\n/)
    dea[4] = "优惠券编号: #{download_num}"
    desc = dea.join("\r\n")

    `cd coupon && ./gen_demo.sh '#{coupon.name}' '#{desc}' ../public#{path} #{Photo.img_url(photo_id, :t2)}`
    return path
  end
  
  def gen_tmp_checkin_coupon_img
    path = share_coupon_img_path
    return path if File.exist?("public"+path)
    `cd coupon && ./gen_tmp.sh '#{self.download_num}' '#{coupon.img.url}' ../public#{path}`
    return path
  end

  #优惠券的下载编号。 优惠券的编号 + 当前下载编号
  def download_num
    "#{coupon.num}-#{num.to_s.rjust(3,'0')}"
  end
  
  def share_coupon_img_path
    "/uploads/tmp/cpd_#{self.id}.jpg"
  end

  #优惠券下发后没有收到时间的， 30秒后至3分钟内自动重发
  def self.auto_resend(tim = Time.now)
    self.where({dat: {"$gte" => tim - 180, "$lte" => tim - 30}, sat: nil, uat: nil }).each do |cpd|
      if ENV["RAILS_ENV"] == "production"
        Xmpp.send_chat("scoupon",cpd.uid,cpd.message, cpd.id)  
      else
        puts "scoupon,#{cpd.uid},#{cpd.message}, #{cpd.id}"
      end
    end
  end
  
end