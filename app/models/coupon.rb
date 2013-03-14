# coding: utf-8

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
  field :users, type:Array #{id:用户id,dat:下载时间,uat:使用时间,[photo:图片id]}
  #TODO: 一个用户可以多次下载一个优惠券：#{id:用户id,dat:下载时间,[{dat:下载时间,uat:使用时间}]}
  #但是这样解决不了分享类优惠券的多次下载，因为每次图片不一样，但是请求的coupon id都一样
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
  
  def shop
    Shop.find_by_id(shop_id)
  end
  
  def message
    "[优惠券:#{name}:#{shop.name}:#{self._id}:#{Time.now.strftime('%Y-%m-%d %H：%M')}]"
  end

  def send_coupon(user_id,photo_id=nil)
    return if downed(user_id) #所有的优惠券都只能下载一次
    download(user_id,photo_id)
    xmpp1 = Xmpp.chat("s#{shop_id}",user_id,message)
    logger.info(xmpp1)
    return xmpp1 if ENV["RAILS_ENV"] != "production"
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp1) 
  end
  
  def allow_send_checkin?(user_id)
    ckin = $redis.zrange("ckin#{self.shop_id.to_i}", 0, -1)
    
    case self.rule.to_i
    when 0
      return true unless ckin.include?(user_id.to_s)
    when 1
      return true if !ckin.include?(user_id.to_s) && ckin.size < self.rulev.to_i
    when 2
      return true if Checkin.where({sid: self.shop_id, uid: user_id}).count == 1
    when 3
      unless self.users.to_a.detect{|u| u['id'] == user_id}
        return true if Checkin.where({sid: self.shop_id, uid: user_id}).group_by{|s| s.id.generation_time.to_date}.count >= self.rulev.to_i
      end
    end
  end
  
  def download(user_id, photo_id=nil)
    if photo_id==nil
      self.add_to_set(:users, {"id" => user_id, "dat" => Time.now})
    else
      self.add_to_set(:users, {"id" => user_id, "dat" => Time.now, photo: photo_id})
      gen_share_coupon_img(Photo.find_by_id(photo_id))
    end
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
  
  def downed(user_id)
    return nil if self.users.nil?
    self.users.detect { |u| u['id'].to_s == user_id.to_s }
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

  def gen_share_coupon_img_by_user(user)
    down = downed(user.id)
    return if down.nil?
    gen_share_coupon_img(Photo.find_by_id(down["photo"]))
    #下载时和查看时都尝试生成优惠券的图片。这里是查看时，download方法是下载时
  end
    
  def gen_share_coupon_img(photo)
    path = share_coupon_img_path(photo.id)
    return path if File.exist?("public"+path)
    `cd coupon && ./gen_demo.sh '#{name}' '#{desc}' ../public#{path} #{photo.img.url(:t2)}`
    return path
  end
  
  def share_coupon_img_path(photo_id)
    "/uploads/tmp/cp_#{self.id}_#{photo_id}.jpg"
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
