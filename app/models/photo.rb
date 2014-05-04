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
  #field :like, type:Array # 从redis中取
  field :com, type:Array #评论 [{"id" => 用户id, ‘name’ => '赞时候的用户昵称', ‘t’ => '时间', 'txt' => "评论", 'hide' => '隐藏'  }]
  field :img
  field :ft1, type:Integer #使用的滤镜
  field :ft2, type:Integer #使用的图片合成
  field :hide, type:Boolean  #隐藏照片
  field :od, type:Integer   #置顶值
  field :total, type:Integer   #多图上传时的总数
  field :time, type:Integer   #上传时客户端时间，unix时间1970到秒
  

  mount_uploader(:img, PhotoUploader)
  
  field :img_tmp
  field :img_processing, type:Boolean
  process_in_background :img
    
  index({user_id:1, room:1})
  index({room:1, updated_at:-1})
  
  def self.img_url(id,type=nil)
    # return self.find_by_id(id).img.url(type) if Rails.env !="production"
    if type
      "http://dface.img.aliyuncs.com/#{id}/0.jpg@200w_200h_1e_1c_80Q.jpg"
      #"http://dface.oss.aliyuncs.com/#{id}/#{type}_0.jpg"
    else
      "http://dface.oss.aliyuncs.com/#{id}/0.jpg"
    end
  end

  def img_url(type=nil)
    if type
      "http://dface.img.aliyuncs.com/#{self.id}/0.jpg@200w_200h_1e_1c_90Q.jpg"
    else
      "http://dface.oss.aliyuncs.com/#{self.id}/0.jpg"
    end
  end  
  
  
  def desc_multi
    "#{total_str}#{desc}"
  end
  
  def total_str
    if total && total>1
      "#{total}:"
    else
      ""
    end
  end
  
  def share_url
    "http://www.dface.cn/web_photo/show?id=#{self.id}"
  end
  
  def mid
    "ckn#{self.id}"
  end
  
  def self.uptoken(uid)
    upopts = {
      :scope => "dphoto", 
      :expires_in => 720000, 
      :callback_url => "http://42.121.79.211/photos/callback",
      :callback_body => "from=$(x:from)&room=$(x:room)&id=$(x:id)&key=$(etag)&size=$(fsize)",
      :callback_body_type => "application/x-www-form-urlencoded"
    }
    Qiniu::RS.generate_upload_token(upopts)
  end
  
  def enqueue_in(number_of_seconds_from_now, klass, *args)
    if number_of_seconds_from_now<1
      Resque.enqueue(klass, *args) 
    else
      Resque.enqueue_in(number_of_seconds_from_now, klass, *args)
    end
  end
  
  def enqueue_job(klass, *args)
    sec = total.to_i*5 #等待多图上传完成，暂不处理多图上传失败
    #TODO: 多图实际判断全部传成功
    enqueue_in(sec.seconds,klass, *args)
  end
  
  def after_async_store
    self.add_to_checkin
    if img.url.nil?
      Xmpp.error_notify("图片async处理时img:#{img}的url为空")      
      return
    end
    send_wb if weibo
    send_qq if qq
    if weibo || qq || (wx && wx>0)
      send_coupon
      Lord.assign(room,user_id) if t==1 && desc && desc.index("我是地主")
      #Rails.cache.delete("UP#{self.user_id}-5")
    end
    enqueue_job(PhotoNotice, self.id) unless Os.overload?
    return if ENV["RAILS_ENV"] == "test"
    enqueue_job(XmppRoomMsg2, room.to_i.to_s, user_id, "[img:#{self._id}]#{self.desc_multi}", mid ,1)
    rand_like
    if room==$zwyd.to_s
      gen_zwyd
      zwyd_send_link
      zwyd_ali_syn
    end
    if room=="21838292" || room=="21837985"
      nyd = NewYearWish.new(data: [], total: 0, template: 3)
      nyd._id = self._id
      nyd.save
      gen_nyd
      nyd_send_link
      #nyd_ali_syn
    end    
  end
  
  def nyd_img_url
    #"http://dface.img.aliyuncs.com/#{id}/0.jpg@268w_360h_1e_1c_80Q.jpg"
    "http://www.dface.cn/nyd#{id}.jpg"
  end
  
  def zwyd_ali_syn
    `/mnt/Oss/oss2/osscmd put /mnt/lianlian/public/zw#{self.id}.jpg  oss://dface/#{self.id}/0.jpg`
    `/mnt/Oss/oss2/osscmd put /mnt/lianlian/public/tzw#{self.id}.jpg  oss://dface/#{self.id}/t2_0.jpg`
  end

  def nyd_ali_syn
    `/mnt/Oss/oss2/osscmd put /mnt/lianlian/public/nyd#{self.id}.jpg  oss://dface/#{self.id}/0.jpg`
    `/mnt/Oss/oss2/osscmd put /mnt/lianlian/public/tnyd#{self.id}.jpg  oss://dface/#{self.id}/t2_0.jpg`
  end
    
  def zwyd_pre_notice
    if room==$zwyd.to_s
      Xmpp.send_gchat2($gfuid, self.room.to_i, self.user_id, "你的专属心愿卡片正在制作中..., 请稍候")
    end
  end
  
  def nyd_pre_notice
    if room=="21838292" || room=="21837985"
      Xmpp.send_gchat2($gfuid, self.room.to_i, self.user_id, "你的马年心愿卡正在制作中…请默数15秒")
    end
  end
  
  

  def zwyd_send_link
    desc = self.desc
    desc = "" if desc.nil?
    desc = desc[6..-1] if desc[0,6]=='#我的心愿#'
      txt = "[img:faqzwyd#{self.id}]\##{desc}\#。赶快戳我分享到朋友圈集祝福赢千元红包吧😍"
      url = "http://dface.cn/zwyd_wish?id=#{self.id}"
      Xmpp.send_link_gchat($gfuid, self.room.to_i, self.user_id, txt,url, "FAQzw#{self.id}")
      attrs = " NOLOG='1'  url='#{url}' "
      ext = "<x xmlns='dface.url'>#{url}</x>"
      Xmpp.send_chat($gfuid, self.user_id, "#{self.user.name}的马年心愿：\##{desc}\# 赶快戳我分享到朋友圈集祝福赢千元红包吧😍 #{url}", "zwd#{self.id}#{Time.now.to_i}" , " NOLOG='1' " )
      zwyd = ZwydWish.new(data: [], total: 0)
      zwyd._id = self._id
      zwyd.save
      Xmpp.send_link_gchat($gfuid, self.room.to_i, self.user_id, txt,url, "FAQzw#{self.id}")#重发,防止消息丢失
  end
  
  def nyd_send_link
    desc = self.desc
    desc = "春节快乐" if desc.nil? || desc==""
    desc = desc[10..-1] if desc[0,10]=='#我的马年心愿#'
    txt = "[img:faqnyd#{self.id}]快来看！有神秘大人物发来了2014春节祝福： #{desc}。" 
    url = "http://shop.dface.cn/new_year_wish?id=#{self.id}"
    Xmpp.send_link_gchat($gfuid, self.room.to_i, self.user_id, txt,url, "FAQnyd#{self.id}")
    attrs = " NOLOG='1'  url='#{url}' "
    ext = "<x xmlns='dface.url'>#{url}</x>"
    Xmpp.send_chat($gfuid, self.user_id, "快来看！神秘大人物为#{self.user.name}发来了2014春节祝福！ #{url}", "nyd#{self.id}#{Time.now.to_i}" , " NOLOG='1' " )
    Xmpp.send_link_gchat($gfuid, self.room.to_i, self.user_id, txt,url, "FAQnyd#{self.id}")
  end
  
  def zwyd_face_detect
    begin
      json = Rekognition.detect(Photo.img_url(self.id, :t2))
      puts json
      if json
        arr = Rekognition.decode_info(json)
        return nil if arr==nil
        arr = arr.map {|x| x*640/200}
        return arr
      end
    rescue Exception => e
      Xmpp.error_notify(e.to_s)
    end
  end
  
  def nyd_face_detect
    begin
      json = Rekognition.detect(Photo.img_url(self.id, :t2))
      puts json
      if json
        arr = Rekognition.decode_info(json)
        return nil if arr==nil
        arr = arr.map {|x| x*640/200}
        return arr
      end
    rescue Exception => e
      Xmpp.error_notify(e.to_s)
    end
  end
  
  def gen_zwyd
    url = Photo.img_url(self.id)
    arr = zwyd_face_detect
    arr = [0, 0, 0, 0] if arr.nil?
    info = arr
    info[2] = info[3] if info[2] < info[3]
    infostr = info[0,3].join(" ")
    puts infostr
    `cd coupon && ./gen_zwyd.sh '#{url}' #{infostr} #{self.id}.png zw#{self.id}.jpg`
  end
  
  def gen_nyd
    url = Photo.img_url(self.id)
    `cd coupon && ./gen_nyd.sh '#{url}' #{self.id}.png nyd#{self.id}.jpg`
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
  
  def is_multi?
    self.total.to_i > 1
  end
  
  def multi_photos
    return {} if total.nil? || total<2
    photos = []
    thumbs = []
    (2..total).each do |x|
      photos.push "http://dphoto.qiniudn.com/#{self.user_id}/#{self.time}-#{x}"
      thumbs.push "http://dphoto.qiniudn.com/#{self.user_id}/#{self.time}-#{x}-thumb"
      #thumbs.push "http://dphoto.qiniudn.com/#{self.user_id}/#{self.time}-#{x}?imageView/1/w/200/h/200/q/85"
    end
    {photos: photos, thumb2s: thumbs}
  end
  
  def thumb2_urls
    return "" if total.nil? || total<2
    str = multi_photos[:thumb2s].join(",")
    "<x xmlns='dface.thumb2s'>#{str}</x>"
  end
  
  def photos_urls
    return "" if total.nil? || total<2
    str = multi_photos[:photos].join(",")
    "<x xmlns='dface.photos'>#{str}</x>"
  end
  
  
  def logo_thumb_hash
    #{:logo => self.img.url, :logo_thumb2 => self.img.url(:t2)  }
    {:logo => self.img_url, :logo_thumb2 => self.img_url(:t2)  }
  end
  
  def top10_like(u=nil)
    arr = like(10)
  end
  
  def top10_comment(u=nil)
    return [] if self.com.nil? || self.com.size==0
    coms = self.com.to_a.select{|m| !m['hide']}
    return coms if coms.size<=10
    coms[-10..-1]
  end
  

  
  def output_hash_to_user(u=nil)
    hash = basic_output
    hash.merge!( {like:self.top10_like(u), comment: top10_comment(u), time:cati})
  end
  
  def basic_output
    hash = {id: self._id, user_name: self.user.name , user_id: self.user_id, room: self.room, desc: self.desc, weibo:self.weibo, qq:self.qq, mid:mid}
    hash.merge!( {od:self.od} ) if self.od
    hash.merge!( logo_thumb_hash)
    hash.merge!( multi_photos)
  end
  
  def output_hash
    hash = basic_output
    hash.merge!( {like:self.like, comment: self.com.to_a.select{|m| !m['hide']}, time:cati} )
  end
  
  def output_hash_with_username
    output_hash_to_user.merge!( {user_name: user.name} )
  end

  def output_hash_with_shopname
    shopname = shop.nil?? "" : shop.name
    output_hash_to_user.merge!( {shop_name: shopname} )
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
  def hidecom(uid, txt=nil)
    ncom = com
    comment = ncom.find{|x| x['id'].to_s == uid.to_s && (txt==nil || x['txt'] == txt) }
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
  def like(num=-1)
    $redis.zrevrange("Like#{self.id}", 0, num, withscores:true).to_a.map{|m| {"t" => Time.at(m[1]), "name" => User.find_by_id(m[0]).try(:name), 'id' => m[0] }}.select{|x| x["name"]!=nil && x["name"][0,6]!="FORBID"}
  end

  def self.init_like_redis
    Photo.where({like: {"$exists" => true}}).each do |photo|
      photo.like.each{|x| $redis.zadd("Like#{photo.id}", x['t'].to_i, x['id']) }
    end
  end
  
  def self.delete(photo)
    Del.insert(photo)
    Gchat.delete_all(mid: photo.mid)
    photo.destroy
  end

  # 图片的来源
  def source
    user_id.is_a?(Moped::BSON::ObjectId) ? 0 : 1 
  end

  #图片来商家么
  def from_shop?
    source == 1
  end


end
