# coding: utf-8

class Coupon
  include Mongoid::Document
  
  field :shop_id, type: Integer
  field :name 
  field :desc
  #  field :endt, type:DateTime
  field :users, type:Array #{id:用户id,dat:下载时间,uat:使用时间}
  #TODO: 一个用户可以多次下载一个优惠券：#{id:用户id,dat:下载时间,[{dat:下载时间,uat:使用时间}]}
  field :img
  mount_uploader :img, CouponUploader

  
  def shop
    Shop.find_by_id(shop_id)
  end
  
  def message
    "[优惠券:#{name}:#{shop.name}:#{self._id}:#{Time.now.strftime('%Y-%m-%d %H:%M')}]"
  end

  def send_coupon(user_id)
    #TODO: 如果有还未使用的优惠券，不再次下发优惠券
    download(user_id)
    xmpp1 = "<message to='#{user_id}@dface.cn' from='s#{shop_id}@dface.cn' type='chat'><body>#{message}</body></message>"
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp1) 
    xmpp2 = "<message to='#{user_id}@dface.cn' from='#{shop_id}@c.dface.cn' type='groupchat'><body>收到一张优惠券：#{name}</body></message>"
    logger.info(xmpp1)
    logger.info(xmpp2)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2) 
  end
  
  def download(user_id)
    self.add_to_set(:users, {id:user_id, dat:Time.now})
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

end
