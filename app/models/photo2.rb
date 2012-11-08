#个人聊天时发送图片

class Photo2
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :to_uid #发给个人
  field :img
  mount_uploader(:img, Photo2Uploader)
  
  field :img_tmp
  store_in_background :img
  
  index({ user_id: 1 })
  
  def after_async_store
    xmpp = "<message id='#{self.id}' to='#{to_uid}@dface.cn' from='#{user_id}@dface.cn' type='chat'><body>[img:#{self.id}]</body></message>"
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
  def user
    User.find(self.user_id)
  end

  
  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    self.attributes.merge!( logo_thumb_hash).merge!({id: self._id})
  end

end
