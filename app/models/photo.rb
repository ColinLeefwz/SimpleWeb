# encoding: utf-8
#用户在聊天室上传的图片

class Photo
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  
  
  field :user_id, type: Moped::BSON::ObjectId
  field :room #发给聊天室
  field :desc
  field :t, type:Integer #图片类型：1拍照；2选自相册
  field :weibo, type:Boolean
  field :like, type:Array #赞
  field :com, type:Array #评论
  field :img
  mount_uploader(:img, PhotoUploader)
  
  field :img_tmp
  #field :img_processing, type:Boolean
  store_in_background :img
    
  index({user_id:1, room:1})
  index({room:1, updated_at:-1})
  
  
  def after_async_store
    if weibo
      str = "我刚刚用\#脸脸\#在\##{shop.name}\#分享:\n#{desc2} \n(来自脸脸 http://www.dface.cn/a?v=3 )"
      Resque.enqueue(WeiboPhoto, $redis.get("wbtoken#{user_id}"), str, img.url)
    end
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => room , :message => "[img:#{self._id}]#{self.desc}",
        :uid => user_id)
  end
  
  def user
    User.find(self.user_id)
  end
  
  def shop
    Shop.find(self.room)
  end
  
  def desc2
    if desc.nil? || desc.length<1
      count = Photo.where({user_id:self.user_id,room:self.room,desc:nil}).count
      count>1? count : ""
    else
      desc
    end
  end

  
  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    hash = {id: self._id, user_id: self.user_id, room: self.room, desc: self.desc, weibo:self.weibo}
    hash.merge!( logo_thumb_hash)
    hash.merge!( {like:self.like, comment:self.com, user_name: user.name, time:cati} )
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
  
  def Photo.init_updated_at
    Photo.all.each do |x|
      x.updated_at=Time.now
      x.save!
    end
  end

end
