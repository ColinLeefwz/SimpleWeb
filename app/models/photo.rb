# encoding: utf-8
#用户在聊天室上传的图片

class Photo
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  
  
  field :user_id, type: Moped::BSON::ObjectId
  field :room #发给聊天室
  field :desc
  field :t, type:Integer #图片类型：1拍照；2选自相册
  field :weibo, type:Boolean #是否分享到新浪微博
  field :qq, type:Boolean  #是否分享到QQ空间
  field :wx, type:Integer   #分享到微信: 1个人,2朋友圈, 3都分享了
  #field :like, type:Array #赞 [{"id" => 用户id, ‘name’ => '赞时候的用户昵称', ‘t’ => '时间' }]
  field :com, type:Array #评论 [{"id" => 用户id, ‘name’ => '赞时候的用户昵称', ‘t’ => '时间', 'txt' => "评论", 'hide' => '隐藏'  }]
  field :img
  field :hide, type:Boolean  #隐藏照片
  mount_uploader(:img, PhotoUploader)
  
  field :img_tmp
  field :img_processing, type:Boolean
  process_in_background :img
    
  index({user_id:1, room:1})
  index({room:1, updated_at:-1})
  
  def self.img_url(id,type=nil)
    # return self.find_by_id(id).img.url(type) if Rails.env !="production"
    if type
      "http://oss.aliyuncs.com/dface/#{id}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/dface/#{id}/0.jpg"
    end
  end
  
  def share_url
    "http://www.dface.cn/web_photo/show?id=#{self.id}"
  end
  
  
  def after_async_store
    if img.url.nil?
      Rails.logger.error("async_store3:#{self.class},#{self.id}")
      return
    end
    send_wb if weibo
    send_qq if qq
    if weibo || qq || (wx && wx>0)
      send_coupon
      send_pshop_coupon
      Lord.assign(room,user_id) if t==1 && desc && desc.index("我是地主")
      Resque.enqueue(PhotoNotice, self.id) unless Os.overload?
      #Rails.cache.delete("UP#{self.user_id}-5")
    end
    return if ENV["RAILS_ENV"] == "test"
    Resque.enqueue(XmppRoomMsg2, room.to_i.to_s, user_id, "[img:#{self._id}]#{self.desc}")
    rand_like
  end

  #马甲随机赞
  #第一次在room中发送图片，必赞
  #非第一次在room中发图， 10分之一的概率赞
  def rand_like
    Resque.enqueue_in(40.seconds, PhotoLike, self._id, self.user.gender) if first_in_room? || rand(10).to_i == 0
  end

  #第一次在room中发图片么？
  def first_in_room?
    Photo.where({room: room, user_id: user_id, _id: {"$ne" => _id} }).limit(1).only(:_id).blank?
  end
  
  def send_wb
    if desc && desc.length>0
      str = "#{desc2} ,我在\##{shop.name}\#\n(来自脸脸: http://www.dface.cn/a?v=3 )"
    else
      str = "我刚刚用\#脸脸\#分享了一张图片:\n#{desc2} 我在\##{shop.name}\#\n(脸脸下载地址: http://www.dface.cn/a?v=3 )"
    end
    #shop_wb = BindWb.wb_name(room)
    #str += "@#{shop_wb}" if shop_wb
    Resque.enqueue(WeiboPhoto, $redis.get("wbtoken#{user_id}"), str, share_url)
  end
  
  def send_qq(direct=false)
    title = "我在\##{shop.name}"
    text = "刚刚用脸脸分享了一张图片。(脸脸下载地址: http://www.dface.cn/a?v=18 )"
    if direct
      QqPhoto.perform(user_id, title, text, share_url, desc)
    else
      Resque.enqueue(QqPhoto, user_id, title, text, share_url, desc)
    end
  end

  
  def send_coupon
    if shop.sub_coupon_by_share
      coupons = shop.allow_sub_coupons(user_id)
      coupons.each{|coupon| coupon.send_coupon(user_id)}
    end
    coupon = shop.share_coupon
    return if coupon.nil?
    if coupon.share_text_match(desc) && coupon.allow_send_share?(user_id.to_s)
      return coupon.send_coupon(user_id,self.id)
    end
    return nil
  end

  def send_pshop_coupon
    return nil if shop.psid.blank?
    return nil if (pshop = Shop.find_by_id(shop.psid)).nil?
    coupon = pshop.share_coupon
    return nil if coupon.nil?
    if coupon.share_text_match(desc) && coupon.allow_send_share?(user_id.to_s, shop.id.to_i)
      ret = coupon.send_coupon(user_id,self.id, room)
      return [shop.psid,ret]
    end
    return nil
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
    hash.merge!( {like:self.like, comment:self.com, time:cati} )
  end
  
  def output_hash_with_username
    output_hash.merge!( {user_name: user.name} )
  end

  def output_hash_with_shopname
    shopname = shop.nil?? "" : shop.name
    output_hash.merge!( {shop_name: shopname} )
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
          c = Checkin.where({photos:p.id}).first
          c.pull(:photos, p.id) if c
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

  def like_user_names
    return if self.like.blank?
    self.like.to_a.map{|m| User.find_by_id(m['id']).try(:name)}.compact.join(', ')
  end


  #隐藏评论
  def hidecom(uid, t)
    comment = com.find{|x| x['id'].to_s == uid && x['t'].localtime.to_s == t }
    return if comment.nil?
    comment["hide"] = true
    self.save!
  rescue
    nil
  end

  #取消评论的隐藏
  def unhidecom(uid, t)
    comment = com.find{|x| x['id'].to_s == uid && x['t'].localtime.to_s == t }
    return if comment.nil?
    comment.delete("hide")
    self.save!
  rescue
    nil
  end

  #like重写， 现在的like是从redis中取
  def like
    $redis.zrevrange("Like#{self.id}", 0, -1, withscores:true).map{|m| {"t" => Time.at(m[1]), "name" => User.find_by_id(m[0]).try(:name), 'id' => m[0] }}
  end

  def self.init_like_redis
    Photo.where({like: {"$exists" => true}}).each do |photo|
      photo.like.each{|x| $redis.zadd("Like#{photo.id}", x['t'].to_i, x['id']) }
    end
  end


end
