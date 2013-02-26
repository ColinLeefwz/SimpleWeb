# coding: utf-8

class Coupon
  include Mongoid::Document
  
  field :shop_id, type: Integer
  field :name 
  field :desc
  #field :ratio, type:Integer #取消
  field :t, type: Integer #发布的方式,1.是图文混合模式发布的，2. 是全图模式发布的,
  field :t2, type: Integer #发布的方式,1.签到触发，2. 图片分享到微博触发类,  
  field :text #图片分享到微博触发类, 必须包含的文字。
  field :hidden, type:Integer #状态， 1.是停用
  #  field :endt, type:DateTime
  field :users, type:Array #{id:用户id,dat:下载时间,uat:使用时间,[img:图片id]}
  #TODO: 一个用户可以多次下载一个优惠券：#{id:用户id,dat:下载时间,[{dat:下载时间,uat:使用时间}]}
  field :rule #0每日签到优惠，1每日前几名签到优惠，2新用户首次签到优惠，3常客累计满多少次签到优惠。
  field :rulev #1每日前几名签到优惠的数量;3常客累计满多少次签到优惠的数量。
  field :img
  mount_uploader :img, CouponUploader
  field :img_tmp
  store_in_background :img
  
  field :img2
  mount_uploader :img2, Coupon2Uploader
  
  # 生成coupon image, 然后调用img_tmp='', CarrierWave::Workers::StoreAsset.perform("Coupon",id.to_s,"img")
  
  index({ shop_id: 1})
  

  #validates_presence_of :img, :message => "必须上传优惠券图片." #目前存在测试券，图片自动生成的，不通过img上传获得。
  
  def shop
    Shop.find_by_id(shop_id)
  end
  
  def message
    "[优惠券:#{name}:#{shop.name}:#{self._id}:#{Time.now.strftime('%Y-%m-%d %H：%M')}]"
  end

  def send_coupon(user_id)
    download(user_id)
    xmpp1 = Xmpp.chat("s#{shop_id}",user_id,message)
    logger.info(xmpp1)
    return xmpp1 if ENV["RAILS_ENV"] != "production"
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp1) 
  end

  def allow_send_share?(t)
    return true if t.match(self.text)
  end
  
  def allow_send_checkin?(user_id)
    ckin = $redis.zrange("ckin#{self.shop_id.to_i}", 0, -1)
    case self.rule.to_i
    when 0
      return true unless ckin.include?(user_id)
    when 1
      return true if !ckin.include?(user_id) && ckin.size < self.rulev
    when 2
      return true if Checkin.where({sid: self.shop_id, uid: user_id}).count == 1
    when 3
      return true if Checkin.where({sid: self.shop_id, uid: user_id}).count == self.rulev
    end
  end


#  def allow_send?(user_id)
#    if self.ratio
#      return false if ratio < Random.rand(100)
#    end
#    al = true
#    al = false if self.rule.to_i == 0 && self.users.to_a.detect{|u| user_id == u['id']}
#    al = false if self.rule.to_i == 1 && self.users.to_a.detect{|u| user_id == u['id'] && u['uat'].nil?  }
#    al
#  end

  
  def download(user_id)
    self.add_to_set(:users, {"id" => user_id, "dat" => Time.now})
  end

  def use(user_id)
    #db.coupons.update({'users.id':ObjectId("502e61bfbe4b1921da000001")},{$set: {'users.$.uat':111}})
    #    Coupon.collection.find(_id:self._id, "users.id" => user_id).update(:$set => {'users.$.uat' => Time.now} )
    downed = self.users.detect { |u| u['id'] == user_id && u['uat'].nil? }
    if downed
      downed.update("uat" => Time.now)
      self.save
    end
  end

  def use_users
    self.users.to_a.select{|s| s['uat']}.sort{|x,y| y['uat'] <=> x['uat']}
  end

  def down_users
    self.users.to_a.sort{|x,y| y['dat'] <=> x['dat']}
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
    if self.t.to_i == 1 || self.t2==2
      name = self.name
      desc = self.desc
      img = self.img2
      `cd coupon && ./gen_demo.sh '#{name}' '#{desc}' ../public/uploads/tmp/coupon_#{self.id}.jpg ../public/#{img}`
      self.img_tmp = "coupon_#{self.id}.jpg"
      self.save
      CarrierWave::Workers::StoreAsset.perform("Coupon",self.id.to_s,"img")
    end
  end



  def deply
    self.update_attribute(:hidden, 1)
  end

  def show_rule
    ['每日签到优惠', '每日前几名签到优惠','新用户首次签到优惠','累计签到优惠'][self.rule.to_i]
  end

  def show_t2
    ['签到类','分享类'][self.t2.to_i-1]
  end

end
