# coding: utf-8

class Coupon
  include Mongoid::Document
  include Dels
  
  field :shop_id, type: Integer
  field :name 
  field :desc
  field :rewards, type:Integer
  field :t, type: Integer #发布的方式,1.是图文混合模式发布的，2. 是全图模式发布的
  field :flag, type:Integer #状态， 1.是停用
  #  field :endt, type:DateTime
  field :users, type:Array #{id:用户id,dat:下载时间,uat:使用时间}
  #TODO: 一个用户可以多次下载一个优惠券：#{id:用户id,dat:下载时间,[{dat:下载时间,uat:使用时间}]}
  field :rule # 0代表一个用户只能下载一次，1代表一个用户只能有一张未使用的，2代表无限制
  field :img
  mount_uploader :img, CouponUploader

  validates_presence_of :img, :message => "必须上传优惠券图片."
  
  def shop
    Shop.find_by_id(shop_id)
  end
  
  def message
    "[优惠券:#{name}:#{shop.name}:#{self._id}:#{Time.now.strftime('%Y-%m-%d %H：%M')}]"
  end

  def send_coupon(user_id)
    if self.rule.to_i == 0
      return false if self.users.to_a.detect{|u| user_id == u['id']}
    end

    if self.rule.to_i ==  1
      return false if self.users.to_a.detect{|u| user_id == u['id'] && u['uat'].nil? }
    end

    #TODO: 根据rule判断是否下发
    download(user_id)
    xmpp1 = "<message to='#{user_id}@dface.cn' from='s#{shop_id}@dface.cn' type='chat'><body>#{message}</body></message>"
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp1) 
    xmpp2 = "<message to='#{user_id}@dface.cn' from='#{shop_id}@c.dface.cn' type='groupchat'><body>收到一张优惠券：#{name}</body></message>"
    logger.info(xmpp1)
    logger.info(xmpp2)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2) 
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
    demo.desc = "测试券"
    demo.save
    `cd coupon && ./gen_demo.sh '#{demo.name}' ../public/#{demo._id}.jpg`
    demo
  end

  def deply
    self.update_attribute(:flag, 1)
  end

  def show_rule
    ['只能下载一次', '只能有一张未使用','无限制'][self.rule.to_i]
  end


end
