#个人聊天时发送图片

class Sound2
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :to_uid #发给个人
  field :sec, type:Integer #语音长度：秒
  field :img
  mount_uploader(:img, Sound2Uploader)
  
  field :img_tmp
  store_in_background :img if Rails.env=="production"
  
  index({ user_id: 1 })
  
  
  def self.img_url(id,type=nil)
    if type
      "http://oss.aliyuncs.com/dface2/#{id}/#{type}_0.aac"
    else
      "http://oss.aliyuncs.com/dface2/#{id}/0.aac"
    end
  end
  
  def after_async_store
    if Rails.env == "production"
      Resque.enqueue(XmppMsg, user_id, to_uid, "[sound:#{self.id}]#{self.sec}")
    else
      Xmpp.send_chat(user_id, to_uid, "[sound:#{self.id}]#{self.sec}")
    end
  end
  
  def user
    User.find_by_id(self.user_id)
  end

end
