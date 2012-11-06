#用户在聊天室上传的图片

class Photo
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :room #发给聊天室
  field :desc
  field :weibo, type:Boolean
  field :img
  mount_uploader(:img, PhotoUploader) { def aliyun_bucket; "dface"+bucket_suffix ; end }
  
  field :img_tmp
  #field :img_processing, type:Boolean
  store_in_background :img
  
  
  index({user_id:1, room:1})
  
  def user
    User.find(self.user_id)
  end
  
  def shop
    Shop.find(self.room)
  end

  
  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb => self.img.url(:t1), :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    self.attributes.merge!( logo_thumb_hash).merge!({id: self._id})
  end

end
