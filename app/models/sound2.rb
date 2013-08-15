#个人聊天时发送图片

class Sound2
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :to_uid #发给个人
  field :sec, type:Integer #语音长度：秒

  index({ user_id: 1 })
  
  def self.uptoken(uid)
    upopts = {
      :scope => "sound", 
      :expires_in => 720000, 
      :callback_url => "http://42.121.79.211/sound2s/callback",
      :callback_body => "sec=$(x:sec)&key=$(etag)&size=$(fsize)&uid=$(endUser)",
      :callback_body_type => "application/x-www-form-urlencoded",
      :customer => uid}
    Qiniu::RS.generate_upload_token(upopts)
  end
  
  def self.test_upload
    token = uptoken("uid")
    local_file = 'public/images/arrow.png'
    data = Qiniu::RS.upload_file :uptoken => token, :file => local_file, :bucket =>"sound", 
      :key => Time.now.to_i.to_s, :callback_params => {sec:10}
    data
  end
  
  def self.callback
    snd = Sound2.new
    snd._id = params[:key]
    snd.sec = params[:sec]
    snd.save!
    snd.after_async_store
  end
  
  def after_async_store
    if Rails.env == "production"
      Resque.enqueue(XmppMsg, user_id, to_uid, "[sound:#{self.id}]#{self.sec}", self.id)
    else
      Xmpp.send_chat(user_id, to_uid, "[sound:#{self.id}]#{self.sec}", self.id)
    end
  end
  
  def user
    User.find_by_id(self.user_id)
  end

end
