#个人聊天时发送图片

class Photo2
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :to_uid #发给个人
  field :img
  mount_uploader(:img, PhotoUploader) { def aliyun_bucket; "dface2"+bucket_suffix ; end }
  
  def user
    User.find(self.user_id)
  end

  
  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb => self.img.url(:t1), :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    self.attributes.merge!( logo_thumb_hash).merge!({id: self._id})
  end

end
