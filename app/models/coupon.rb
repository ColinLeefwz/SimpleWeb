# coding: utf-8


#优惠券发布规则
#####优惠券发布分两种
######################
##### 第一种优惠券 => 签到类优惠券. 签到类优惠券是用户每天在一个商家第一次签到时,才可以发送的优惠券。 它的规则有四种
#*****1. 每日签到优惠，即用户每天在某商家第一次签到时推送的优惠券.每天没个用户只推送一次。
#*****2. 每日前几名签到优惠， 即某商家每天只给前几名签到的用户推送优惠券，每天每个用户第一次签到有效
#*****3. 新用户首次签到优惠， 即优惠券创建后，用户当天或过期前的某天第一次签到推送优惠券， 每个用户只有一次
#*****4. 累计签到优惠, 即一个老客户在某商家累计满签到多少天推送优惠券，每个用户只有只有一次。
#***** 签到类优惠券和内部商家的关系 =>  一个用户在某一大地点签到时， 它所包含的内部商家有且只有推送规则是“每日签到优惠”类的优惠券。 此规则和在内部商家签到不冲突，即用户在大地点签到和在内部商家签到都可以收到‘每日签到优惠’优惠券。
# 签到类优惠券每种规则同一时间点上只能发布一张有效的优惠券。但用户签到可以一次接收到多张。每天在同一个地点第一次签到有效
#####################
#***** 第二种优惠券 => 分享类优惠券。 用户在商家内分享图片到微博，可以获取商家的分享类优惠券. 其规则有两种
#*****1. 每日分享优惠，即每日分享一个图片即可以收到优惠券一张.
#*****2. 首次分享优惠，即优惠券发布后，首次分享图片
#************* 分享类优惠券同一时间点只能发布一张有效的
#************* 分享类优惠券和分店的关系 => 总店发布的优惠券在分店有效， 即在分店分享图片可以同时获取总店和分店有效的分享类优惠券。




class Coupon
  include Mongoid::Document
  
  field :shop_id, type: Integer
  field :name 
  field :desc
  field :t, type: Integer #发布的方式,1.是图文混合模式发布的，2. 是全图模式发布的,
  field :t2, type: Integer #发布的方式,1.签到触发，2. 图片分享到微博触发类,  
  field :text #图片分享到微博触发类, 必须包含的文字。
  field :hidden, type:Integer #状态， 1.是停用
  #  field :endt, type:DateTime
  field :rule #0每日签到优惠，1每日前几名签到优惠，2新用户首次签到优惠，3常客累计满多少次签到优惠。
  field :rulev #1每日前几名签到优惠的数量;3常客累计满多少次签到优惠的数量。
  field :hint  #优惠券使用时的要求输入信息的消费提示
  
  field :img
  mount_uploader :img, CouponUploader
  field :img_tmp
  field :img_processing, type:Boolean
  process_in_background :img
    
  field :img2
  field :num, type:Integer  #优惠券编号， 每个商家的编号独立


  mount_uploader :img2, Coupon2Uploader
  
  # 生成coupon image, 然后调用img_tmp='', CarrierWave::Workers::StoreAsset.perform("Coupon",id.to_s,"img")
  
  index({ shop_id: 1})

  def self.next_num(sid)
    coupon = self.where({shop_id:sid}).sort({num: -1}).limit(1).first
    (coupon && coupon.num) ? coupon.num.succ : 1
  end
  
  def shop
    Shop.find_by_id(shop_id)
  end

  def send_coupon(user_id,photo_id=nil, sid=nil)
    cpd = CouponDown.download(self, user_id, photo_id, sid)
    if ENV["RAILS_ENV"] != "production"
      return Xmpp.chat("scoupon",user_id, cpd.message, "#{cpd.id}")
    end
    Resque.enqueue(XmppMsg, "scoupon",user_id, cpd.message, "#{cpd.id}")
    return true
  end

  def allow_send_share?(user_id, sid = nil)
    case self.rule.to_i
    when 0
      return !downed_today(user_id)
    when 1
      return !downed(user_id)
    end
  end

  def allow_send_checkin?(user_id)
    case self.rule.to_i
    when 0
      return !downed_today(user_id)
    when 1
      return true if !downed_today(user_id) && $redis.zcard("ckin#{self.shop_id.to_i}") < self.rulev.to_i
    when 2
      return !downed(user_id)
    when 3
      return false if downed(user_id)
      return Checkin.where({sid: self.shop_id, uid: user_id}).count >= self.rulev.to_i
    end
  end

  alias  allowsc? allow_send_checkin?

  def allow_send_checkin?(user_id)
    if $ActiveShops.include?(self.shop_id.to_i)
      return false if  CouponDown.where({sid: shop_id}).limit(1).only(:id).first
    end
    allowsc?(user_id)
  end

  def use_users
    CouponDown.where({cid:self.id, uat:{"$exists" => true}}).sort({uat:-1})
  end

  def down_users
    CouponDown.where({cid:self.id}).sort({dat:-1})
  end
  
  def downed(user_id)
    CouponDown.where({cid:self.id, uid: user_id}).first != nil
  end

  def downed_today(user_id)
    cpd = CouponDown.where({cid:self.id, uid: user_id}).sort({_id:-1}).limit(1).to_a
    return false if cpd.nil? || cpd.size==0
    return cpd[0].dat.to_date == Time.now.to_date
  end  
  
  def self.gen_demo(sid)
    demo = Coupon.new
    demo.shop_id = sid
    demo.name = demo.shop.name+"20元代金券"
    demo.desc = "凭本券可抵扣现场消费人民币20元\r\n本券不兑现/不找零/不开发票,\r\n复印和涂改无效，请于点餐时\r\n有效期至:#{3.days.since.strftime("%Y-%m-%d日18：00")}\r\n本券最终解释权规商家所有"
    demo.t=1
    demo.rule = 2
    `cd coupon && ./gen_demo.sh '#{demo.name}' '#{demo.desc}' ../public/uploads/tmp/coupon_#{demo._id}.jpg pic1.jpg`
    demo.img_tmp = "coupon_#{demo.id}.jpg"
    demo.save
    CarrierWave::Workers::StoreAsset.perform("Coupon",demo.id.to_s,"img")
  end
  
  #图文模式生成图片
  def gen_img
    if self.t.to_i == 1
      name = self.name
      desc = self.desc
      img = self.img2
      `cd coupon && ./gen_demo.sh '#{name}' '#{desc}' ../public/uploads/tmp/coupon_#{self.id}.jpg ../public/#{img}`
      self.img_tmp = "coupon_#{self.id}.jpg"
      self.save
      CarrierWave::Workers::StoreAsset.perform("Coupon",self.id.to_s,"img")
    end
  end

  def gen_img2
    name = self.name
    desc = self.desc
    `cd coupon && ./gen_demo.sh '#{name}' '#{desc}' ../public/uploads/tmp/coupon_#{self.id}.jpg pic1.png`
    self.img_tmp = "coupon_#{self.id}.jpg"
    self.save
    CarrierWave::Workers::StoreAsset.perform("Coupon",self.id.to_s,"img")
  end

  def deply
    self.update_attribute(:hidden, 1)
  end

  def show_rule
    return if self.rule.blank?
    ['每日签到优惠', '每日前几名签到优惠','新用户首次签到优惠','累计签到优惠'][self.rule.to_i]
  end

  def show_rule2
    ['每日分享优惠','首次分享优惠'][self.rule.to_i]
  end

  def show_t2
    ['签到类','分享类'][self.t2.to_i-1]
  end
  
  def has_text?
    text!=nil && text.length>0
  end
  
  def share_text_match(str)
    return true unless has_text?
    return false if str.nil?
    return Shop.str_similar(text.downcase, str.downcase)>0.4
  end
  
  def share_text_hint
    key = has_text?? ",文字中带'#{text}'#{text.length}个字" : ""
    "发送分享图片到新浪微博#{key}，即可获得'#{name}'。"
  end

  def allow_activate?
    if self.t2.to_i == 2
      Coupon.where({t2: 2, hidden: {"$ne" => 1}, shop_id: self.shop_id.to_i}).limit(1).blank?
    else
      Coupon.where({t2: 1, hidden: {"$ne" => 1}, shop_id: self.shop_id.to_i, rule: self.rule }).limit(1).blank?
    end
  end
  
  def self.init_city_coupon_redis
    Coupon.where({hidden:{"$ne" => 1}}).each {|x| $redis.sadd("ACS#{x.shop.city}", x.shop_id)}
  end

end
