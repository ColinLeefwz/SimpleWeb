#用户在聊天时上传的图片

class Photo
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :room #发给聊天室
  field :weibo, type:Boolean
  field :to_uid #发给个人
  field :img
  mount_uploader :img, PhotoUploader
  
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
