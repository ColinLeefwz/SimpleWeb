#商家头像

class ShopLogo
  include Mongoid::Document
  
  field :shop_id, type: Moped::BSON::ObjectId
  field :img
  mount_uploader(:img, LogoUploader)


  def self.img_url(sid,type=nil)
    if type
      "http://oss.aliyuncs.com/logo/#{sid}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/logo/#{sid}/0.jpg"
    end
  end

  def self.shop_logo(shop_id)
    self.where({shop_id: shop_id}).sort({_id: -1}).first
  end

  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb => self.img.url(:t1), :logo_thumb2 => self.img.url(:t2)  }
  end

  def shop
    Shop.find_by_id(shop_id.to_i)
  end

end
