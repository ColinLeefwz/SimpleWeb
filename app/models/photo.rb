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
  field :ft1, type:Integer #使用的滤镜
  field :ft2, type:Integer #使用的图片合成
  field :hide, type:Boolean  #隐藏照片
  field :od, type:Integer   #置顶值

  mount_uploader(:img, PhotoUploader)
  
  field :img_tmp
  field :img_processing, type:Boolean
  process_in_background :img
    
  index({user_id:1, room:1})
  index({room:1, updated_at:-1})
  
  def self.img_url(id,type=nil)
    # return self.find_by_id(id).img.url(type) if Rails.env !="production"
    if type
      "http://dface.oss.aliyuncs.com/#{id}/#{type}_0.jpg"
    else
      "http://dface.oss.aliyuncs.com/#{id}/0.jpg"
    end
  end
  
  def share_url
    "http://www.dface.cn/web_photo/show?id=#{self.id}"
  end
  
  
  def after_async_store
    if img.url.nil?
      Xmpp.error_notify("图片async处理时img:#{img}的url为空")      
      return
    end
    Xmpp.send_gchat2($gfuid, self.room.to_i, self.user_id, "心愿卡片生成中..., 请稍候")
    send_wb if weibo
    send_qq if qq
    if weibo || qq || (wx && wx>0)
      send_coupon

      Lord.assign(room,user_id) if t==1 && desc && desc.index("我是地主")
      Resque.enqueue(PhotoNotice, self.id) unless Os.overload?
      #Rails.cache.delete("UP#{self.user_id}-5")
    end
    return if ENV["RAILS_ENV"] == "test"
    Resque.enqueue(XmppRoomMsg2, room.to_i.to_s, user_id, "[img:#{self._id}]#{self.desc}", "ckn#{$uuid.generate}" ,1)
    rand_like
    if room=="21828958" || room=="21837985"
      gen_zwyd
      zwyd_send_link
    end
  end

  def zwyd_send_link
      text = "😜恭喜~您的专属心愿卡片已经制作完成啦，还能集祝福抽红包噢~戳我看看吧！"
      url = "http://www.dface.cn/zwyd_wish?id=#{self.id}"
      faq = ShopFaq.find('52b2e20c20f3180fbc000021')
      Xmpp.send_link_gchat($gfuid, self.room.to_i, self.user_id, faq.output,url, "zw#{self.id}#{self.user_id}#{Time.now.to_i}")
      attrs = " NOLOG='1'  url='#{url}' "
      ext = "<x xmlns='dface.url'>#{url}</x>"
      surl = ShopFaq.short_url('2.00kfdvGCGFlsXC1b5e64ba39QaSfpB', url)
      Xmpp.send_chat($gfuid, self.user_id, ": 😜恭喜~您的专属心愿卡片已经制作完成啦 #{surl}", "zwd#{self.id}#{Time.now.to_i}" , " NOLOG='1' " )
      zwyd = ZwydWish.new(data: [], total: 0)
      zwyd._id = self._id
      zwyd.save
  end
  
  def gen_zwyd
    url = Photo.img_url(self.id)
    begin
      json = Rekognition.detect(Photo.img_url(self.id, :t2))
      puts json
      if json
        arr = Rekognition.decode_info(json)
        arr = arr.map {|x| x*640/200}
      else
        json = Rekognition.detect(url)
        if json
          arr = Rekognition.decode_info(json)
          max = arr[4,2].max
          arr = arr.map {|x| x*640/max}
        end
      end
    rescue Exception => e
      Xmpp.error_notify(e.to_s)
    end
    puts arr
    arr = [0, 0, 0, 0] if arr.nil?
    info = arr
    info[2] = info[3] if info[2] < info[3]
    infostr = info[0,3].join(" ")
    puts infostr
    `cd coupon && ./gen_zwyd.sh '#{url}' #{infostr} #{self.id}.png zw#{self.id}.jpg`
  end
  
  def self.test_zwyd
    User.first.photos.last.gen_zwyd
  end


  #马甲随机赞
  #第一次在room中发送图片，必赞
  #非第一次在room中发图， 10分之一的概率赞
  def rand_like
    Resque.enqueue_in(40.seconds, PhotoLike, self._id, self.user.gender) if user_first? || rand(10).to_i == 0
  end

  #用户的第一次发图片么？
  def user_first?
    Photo.where({user_id: user_id, _id: {"$ne" => _id} }).limit(1).only(:_id).blank?
  end
  
  def send_wb
    if desc && desc.length>0
      str = "#{desc2} ,我在\##{shop.name}\#\n(来自脸脸: http://www.dface.cn/a?v=3 )"
    else
      str = "我刚刚用\#脸脸\#分享了一张图片:\n#{desc2} 我在\##{shop.name}\#\n(脸脸下载地址: http://www.dface.cn/a?v=3 )"
    end
    #shop_wb = BindWb.wb_name(room)
    #str += "@#{shop_wb}" if shop_wb
    Resque.enqueue(WeiboPhoto, $redis.get("wbtoken#{user_id}"), str, img.url)
  end
  
  def send_qq(direct=false)
    title = "我在\##{shop.name}"
    text = "刚刚用脸脸分享了一张图片。(脸脸下载地址: http://www.dface.cn/a?v=18 )"
    img_url = Photo.img_url(self.id, :t2)
    if direct
      QqPhoto.perform(user_id, title, text, share_url, desc, img_url)
    else
      Resque.enqueue(QqPhoto, user_id, title, text, share_url, desc, img_url)
    end
  end

  
  def send_coupon
    if shop.sub_coupon_by_share
      coupons = shop.allow_sub_coupons(user_id)
      coupons.each{|coupon| coupon.send_coupon(user_id,self.id,self.room.to_i)}
    end

    coupon_names = []
    ####总店的分享优惠券
    coupon_names += send_pshop_coupon
    ####合作商家的分享优惠券
    coupon_names += send_partner_coupons

    coupon = shop.share_coupon
    return if coupon.nil?
    if coupon.share_text_match(desc) && coupon.allow_send_share?(user_id.to_s)
      coupon.send_coupon(user_id,self.id,self.room.to_i)
      coupon_names << coupon.name
    end
    return nil if coupon_names.blank?
    message = "恭喜#{user.name}！收到#{coupon_names.count}张分享优惠券: #{coupon_names.join(',').truncate(50)},马上领取吧！"
    return message if ENV["RAILS_ENV"] != "production"
    Resque.enqueue(XmppNotice, self.room,user_id, message,"coupon#{Time.now.to_i}","url='dface://record/coupon?forward'")
    return nil
  end

  #分店分享图片后， 推送总店的“分享类优惠券”
  #返回值： 总店分享类优惠券的名称
  def send_pshop_coupon
    return [] if shop.psid.blank?
    return [] if (pshop = Shop.find_by_id(shop.psid)).nil?
    coupon = pshop.share_coupon
    return [] if coupon.nil?
    if coupon.share_text_match(desc) && coupon.allow_send_share?(user_id.to_s)
      coupon.send_coupon(user_id,self.id, room)
      return [coupon.name]
    end
    return []
  end


  #合作商家发送“分享优惠券”, 合作商家优惠券没有使用的话不发送
  def send_partner_coupons
    return [] if  $travel.include?(self.room.to_i)
    coupon_names = []
    shop.partners.each do |partner|
      next if (s = Shop.find_by_id(partner[0])).nil?
      next if (coupon = s.share_coupon).nil?
      if coupon.share_text_match(desc) && coupon.allow_send_share?(user_id.to_s, :single => true)
        coupon.send_coupon(user_id,self.id)
        coupon_names << coupon.name
      end
    end
    return coupon_names
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
    hash = {id: self._id, user_name: self.user.name , user_id: self.user_id, room: self.room, desc: self.desc, weibo:self.weibo, qq:self.qq}
    hash.merge!( logo_thumb_hash)
    hash.merge!( {like:self.like, comment: self.com.to_a.select{|m| !m['hide']}, time:cati} )
  end
  
  def output_hash_with_username
    output_hash.merge!( {user_name: user.name} )
  end

  def output_hash_with_shopname
    shopname = shop.nil?? "" : shop.name
    output_hash.merge!( {shop_name: shopname} )
  end
  
  def find_checkin
    #加first的时候必须用order_by, 不能用sort
    Checkin.where({uid:self.user_id,sid:self.room}).order_by("id desc").limit(1).first
  end
  
  def add_to_checkin
    cin = find_checkin
    if cin.nil?
      Xmpp.error_notify("not checkined, but has photo upoladed, photo.id:#{self.id}")      
      return
    end
    cin.push(:photos, self.id)
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
  def hidecom(uid, txt)
    ncom = com
    comment = ncom.find{|x| x['id'].to_s == uid && x['txt'] == txt }
    return "comment #{txt} not found." if comment.nil?
    comment["hide"] = true
    self.set(:com, ncom)
    return nil
  end

  #取消评论的隐藏
  def unhidecom(uid, txt)
    ncom = com
    comment = ncom.find{|x| x['id'].to_s == uid && x['txt'] == txt }
    return "comment #{txt} not found." if comment.nil?
    comment.delete("hide")
    self.set(:com, ncom)
    return nil
  end

  #like重写， 现在的like是从redis中取
  def like
    $redis.zrevrange("Like#{self.id}", 0, -1, withscores:true).to_a.map{|m| {"t" => Time.at(m[1]), "name" => User.find_by_id(m[0]).try(:name), 'id' => m[0] }}
  end

  def self.init_like_redis
    Photo.where({like: {"$exists" => true}}).each do |photo|
      photo.like.each{|x| $redis.zadd("Like#{photo.id}", x['t'].to_i, x['id']) }
    end
  end


end
