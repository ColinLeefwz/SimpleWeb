# coding: utf-8

class Coupon
  include Mongoid::Document
  
  field :shop_id, type: Integer
  field :name 
  field :desc
  field :ratio, type:Integer
  field :t, type: Integer #发布的方式,1.是图文混合模式发布的，2. 是全图模式发布的
  field :hidden, type:Integer #状态， 1.是停用
  #  field :endt, type:DateTime
  field :users, type:Array #{id:用户id,dat:下载时间,uat:使用时间}
  #TODO: 一个用户可以多次下载一个优惠券：#{id:用户id,dat:下载时间,[{dat:下载时间,uat:使用时间}]}
  field :rule # 0代表一个用户只能下载一次，1代表一个用户只能有一张未使用的，2代表无限制
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

  def send_coupon(user_id, sub = true)
    
    send_sub_coupon(user_id) if sub
    return false unless send?(user_id)
    
    download(user_id)
    xmpp1 = "<message to='#{user_id}@dface.cn' from='s#{shop_id}@dface.cn' type='chat'><body>#{message}</body></message>"
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp1) 
  end


  
  def download(user_id)
    self.add_to_set(:users, {"id" => user_id, "dat" => Time.now})
  end

  def use(user_id)
    #db.coupons.update({'users.id':ObjectId("502e61bfbe4b1921da000001")},{$set: {'users.$.uat':111}})
    Coupon.collection.find(_id:self._id, "users.id" => user_id).update(:$set => {'users.$.uat' => Time.now} )
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

  def cat
    (Time.at self._id.to_s[0,8].to_i(16)).strftime("%Y-%m-%d %H:%M")
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
    end
    CarrierWave::Workers::StoreAsset.perform("Coupon",self.id.to_s,"img")
  end



  def deply
    self.update_attribute(:hidden, 1)
  end

  def show_rule
    ['只能下载一次', '只能有一张未使用','无限制'][self.rule.to_i]
  end

  #:t1是小图
  #  def img_url(type=nil)
  #    # 取消
  #    if self.t.to_i == 1
  #      text_img(type)
  #    elsif self.t.to_i == 2
  #      full_img(type)
  #    end
  #  end

  private
  #  def full_img(type)
  #    case type
  #    when :t1
  #      self.img.url(:t1)
  #    else
  #      self.img
  #    end
  #  end
  #
  #  def text_img(type)
  #    case type
  #    when :t1
  #      "/coupon/#{self._id}.jpg_2.jpg"
  #    else
  #      "/coupon/#{self._id}.jpg"
  #    end
  #  end

  def send_sub_coupon(user_id)
    sids = self.shop.shops.to_a
    sids.each do |sid|
      cou = Coupon.where({shop_id: sid}).last
      cou.send_coupon(user_id, false) if cou
    end
  end

  def send?(user_id)
    send = true
    send = false if self.rule.to_i == 0 && self.users.to_a.detect{|u| user_id == u['id']}
    send = false if self.rule.to_i == 1 && self.users.to_a.detect{|u| user_id == u['id'] && u['uat'].nil? }
    send
  end


end
