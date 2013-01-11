# encoding: utf-8
#用户在聊天室上传的图片

class Photo
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :room #发给聊天室
  field :desc
  field :weibo, type:Boolean
  field :img
  mount_uploader(:img, PhotoUploader)
  
  field :img_tmp
  #field :img_processing, type:Boolean
  store_in_background :img
  
  index({user_id:1, room:1})
  
  def after_async_store
    if weibo
      Resque.enqueue(WeiboPhoto, $redis.get("wbtoken#{user_id}"), "在\##{shop.name}\#分享：\n#{desc}", img.url)
    end
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => room , :message => "[img:#{self._id}]#{self.desc}",
        :uid => user_id)  {|response, request, result| puts response }
  end
  
  def user
    User.find(self.user_id)
  end
  
  def shop
    Shop.find(self.room)
  end

  
  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    self.attributes.merge!( logo_thumb_hash).merge!({id: self._id})
  end
  
  def add_to_checkin
    cin = Checkin.where({uid:self.user_id}).order_by("id desc").limit(1).first
    #加first的时候必须用order_by, 不能用sort
    if cin.nil?
      logger.error "Error:\tnot checkined, but has photo upoladed, photo.id:#{self.id}" 
      return
    end
    if cin.sid.to_s==self.room
      cin.push(:photos, self.id)
    else
      logger.error "Error:\tphoto.room:#{self.room} != checkin.sid:#{cin.sid}, photo.id:#{self.id}" 
    end
  end

end
