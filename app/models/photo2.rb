#个人聊天时发送图片

class Photo2
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :to_uid #发给个人
  field :t, type:Integer #图片类型：1拍照；2选自相册
  
  field :img
  mount_uploader(:img, Photo2Uploader)
  field :img_tmp
  field :img_processing, type:Boolean
  process_in_background :img
  
  index({ user_id: 1 })
  
  
  def self.img_url(id,type=nil)
    if type
      "http://oss.aliyuncs.com/dface2/#{id}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/dface2/#{id}/0.jpg"
    end
  end
  
  def after_async_store
    if img.url.nil?
      Rails.logger.error("async_store3:#{self.class},#{self.id}")
      return
    end
    if Rails.env == "production"
      Resque.enqueue(XmppMsg, user_id, to_uid, "[img:U#{self.id}]", self.id)
    else
      Xmpp.send_chat(user_id, to_uid, "[img:U#{self.id}]", self.id)
    end
  end
  
  def user
    User.find_by_id(self.user_id)
  end

  
  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    self.attributes.merge!( logo_thumb_hash).merge!({id: self._id})
  end

end
