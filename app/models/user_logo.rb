#用户头像，最多只有8张

class UserLogo
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :ord, type: Float
  field :img
  mount_uploader(:img, LogoUploader)
  
  index({ user_id: 1, ord: 1 })
  

  def user
    User.find(self.user_id)
  end
  
  def self.logos(uid)
    UserLogo.where({user_id: uid}).order_by([:ord,:asc])
  end

  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb => self.img.url(:t1), :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    logo_thumb_hash.merge!({id: self._id, user_id:self.user_id})
  end

end
