# coding: utf-8

class Coupon
  include Mongoid::Document
  
  field :shop_id, type: Integer
  field :name 
  field :desc
  #  field :endt, type:DateTime
  field :users, type:Array #{id:用户id,dat:下载时间,uat:使用时间}
  field :img
  mount_uploader :img, CouponUploader

  
  def shop
    Shop.find(shop_id)
  end
  
  def message
    "[优惠券:#{name}:#{shop.name}:#{self._id}]"
  end

  def send_coupon(user_id)
    download(user_id)
    xmpp1 = "<message to='#{user_id}@dface.cn' from='s#{shop_id}@dface.cn' type='chat'><body>#{message}</body></message>"
    RestClient.post('http://42.121.98.157:5280/rest', xmpp1) 
    xmpp2 = "<message to='#{user_id}@dface.cn' from='#{shop_id}@c.dface.cn' type='groupchat'><body>收到一张优惠券：#{name}</body></message>"
    logger.info(xmpp1)
    logger.info(xmpp2)
    RestClient.post('http://42.121.98.157:5280/rest', xmpp2) 
  end
  
  def download(user_id)
    self.add_to_set(:users, {id:user_id, dat:Time.now})
  end

  def use(user_id)
    #db.coupons.update({'users.id':ObjectId("502e61bfbe4b1921da000001")},{$set: {'users.$.uat':111}})
    Coupon.collection.find(_id:self._id, "users.id" => user_id).update(:$set => {'users.$.uat' => Time.now} )
  end
  

end
