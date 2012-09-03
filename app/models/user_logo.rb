#用户头像，最多只有8张

class UserLogo
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :ord, type: Float
  field :img
  mount_uploader(:img, PhotoUploader) { def aliyun_bucket; "logo"+bucket_suffix ; end }

  def user
    User.find(self.user_id)
  end
  

  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb => self.img.url(:t1), :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    self.attributes.slice("user_id", "file_size","updated_at","ord").merge!( logo_thumb_hash).merge!({id: self._id})
  end

end
