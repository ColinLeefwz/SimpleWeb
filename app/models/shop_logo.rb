#商家头像

class ShopLogo
  include Mongoid::Document
  
  field :shop_id, type: Moped::BSON::ObjectId
  field :img
  mount_uploader(:img, PhotoUploader) { def aliyun_bucket; "logo"+bucket_suffix ; end }


end
