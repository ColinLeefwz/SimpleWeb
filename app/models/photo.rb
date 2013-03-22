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
  field :qq, type:Boolean
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
    if img.url.nil?
      Rails.logger.error("async_store3:#{self.class},#{self.id}")
      return
    end
    if weibo
      send_wb
      send_coupon
    end
    send_qq if qq
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
      :roomid  => room , :message => "[img:#{self._id}]#{self.desc}",
      :uid => user_id)
  end
  
  def send_wb
    if desc && desc.length>0
      str = "我刚刚用\#脸脸\#分享:\n#{desc2} ,我在\##{shop.name}\#\n(来自脸脸 http://www.dface.cn/a?v=3 )"
    else
      str = "我刚刚用\#脸脸\#分享了一张图片:\n#{desc2} 我在\##{shop.name}\#\n(来自脸脸 http://www.dface.cn/a?v=3 )"
    end
    Resque.enqueue(WeiboPhoto, $redis.get("wbtoken#{user_id}"), str, img.url)
  end
  
  def send_qq(direct=false)
    title = "我在\##{shop.name}"
    text = "刚刚用脸脸分享了一张图片。(来自脸脸 http://www.dface.cn/a?v=18 )"
    if test
      QqPhoto.perform(user_id, title, text, img.url, desc)
    else
      Resque.enqueue(QqPhoto, user_id, title, text, img.url, desc)
    end
  end

  
  def send_coupon
    coupon = shop.share_coupon
    return if coupon.nil?
    if coupon.allow_send_share?(user_id.to_s) && (coupon.text.nil? || (desc && desc.index(coupon.text) ))
      coupon.send_coupon(user_id,self.id)
    end
  end
  
  def user
    User.find_by_id(self.user_id)
  end
  
  def shop
    Shop.find_by_id(self.room)
  end
  
  def desc2
    if desc.nil? || desc.length<1
      ret = ""
      count = Photo.where({user_id:self.user_id,room:self.room,desc:nil}).count
      count.times {|x| ret << " "}
      ret
    else
      desc
    end
  end

  
  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    hash = {id: self._id, user_id: self.user_id, room: self.room, desc: self.desc, weibo:self.weibo, qq:self.qq}
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
  
  def self.fix_error(delete_error=false,pcount=1000)
    Photo.where({img_tmp:{"$ne" => nil}}).sort({_id:-1}).limit(pcount).each do |p|
      next if (Time.now.to_i-p.id.generation_time.to_i < 60)
      begin
        CarrierWave::Workers::StoreAsset.perform("Photo",p.id.to_s,"img")
      rescue Errno::ENOENT => noe
        puts "#{p.id}, 图片有数据库记录，但是文件不存在。"
        if delete_error
          Checkin.where({photos:p.id}).first.pull(:photos, p.id)
          p.destroy 
        end
      rescue Exception => e
        puts e
      end
    end
  end
  
  def Photo.fix_error_of_all_type_image
    #TODO：目前图片先保存在本地文件系统，然后通过store_asset异步上传到阿里云。
    #      所以只能在单机上运行错误监测。如果让多机器可以并行处理？
    Photo.fix_error(false)
    User.fix_head_logo_err1
    UserLogo.fix_error(false)
  end

end
