# coding: utf-8

class Coupon
  include Mongoid::Document
  
  field :shop_id, type: Integer
  field :name 
  field :desc
  field :endt, type:DateTime
  field :users, type:Array
  field :img
  mount_uploader(:img, PhotoUploader) { def aliyun_bucket; "coupon" ; end }

  
  def shop
    Shop.find(shop_id)
  end
  
  def message
    "[优惠券:#{name}:#{shop.name}:#{self._id}]"
  end
  
  def download(user_id)
    self.add_to_set(:users, {id:user_id, dat:Time.now})
  end

  def use(user_id)
    #db.coupons.update({'users.id':ObjectId("502e61bfbe4b1921da000001")},{$set: {'users.$.uat':111}})
    Coupon.collection.find(_id:self._id, "users.id" => user_id).update(:$set => {'users.$.uat' => Time.now} )
  end
  

end
