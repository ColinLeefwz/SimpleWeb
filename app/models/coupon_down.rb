# coding: utf-8

class CouponDown
  include Mongoid::Document

  field :cid, type: Moped::BSON::ObjectId #优惠券
  field :sid, type: Integer #发布商家
  field :uid, type: Moped::BSON::ObjectId #用户
  field :dat, type: DateTime  #下载时间
  field :d_sid, type: Integer #下载时的商家
  field :sat, type: DateTime #收到时间
  field :vat, type: DateTime #查看时间
  field :uat, type: DateTime  #使用时间
  field :u_sid, type: Integer #使用时的商家, 发布商家和下载商家是精确的，而使用商家不一定。因为不摇到现场也可以使用优惠券。
  field :photo_id, type: Moped::BSON::ObjectId # 获得优惠券的分享图片id
  #field :sub_sid, type: Integer #获得主店分享类优惠券时，实际分享发生的分店id, 用:d_sid替换
  field :data #消费时输入的数据，可以是消费金额／手机号码／服务员编号等
  field :num, type:Integer #优惠券下载编号， 每个优惠券独立编号
  field :del, type:Boolean #是否被用户删除
  field :st, type:Integer #优惠券的状态 ，nil／1代表未使用的，2代表已使用的，4代表已过期的，8代表未激活的

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :gender, :birthday, :weibo_home,:show_gender, :to => :user
    option.delegate :name, :city, :to => :shop
    option.delegate :name, :to => :sub_shop
    option.delegate :img, :name, :show_t2, :desc,  :to => :coupon
  end

  index({cid: 1, uid:1})
  index({dat: -1})
  index({uid: 1})
  
  def status
    return 1 if st.nil?
    st
  end
  
  def shop
    Shop.find_by_id(sid)
  end

  def sub_shop
    Shop.find_by_id(d_sid)
  end

  def user
     User.find_by_id(uid)
  end
  
  def coupon
    Coupon.find_by_id(cid)
  end
  
  def photo
    Photo.find_by_id(photo_id)
  end
   
  def message
    s = "[优惠券:#{coupon.name}:#{shop.name}:#{id}:#{d_date}"
    s += ":#{coupon.hint}" if coupon.hint
    s += "]"
    s
  end
  
  def d_date
    (dat.to_time+3600*8).strftime('%Y-%m-%d %H：%M')
  end
  
  def u_date
    return "" if uat.nil?
    (uat.to_time+3600*8).strftime('%Y-%m-%d %H：%M')
  end

  def self.next_num(cid)
    $redis.incr("CPD#{cid}")
    #cpdown = self.where({cid: cid}).sort({num: -1}).limit(1).first
    #(cpdown && cpdown.num) ? cpdown.num.succ : 1
  end
  
  def self.download(coupon, user_id, photo_id=nil, sid = nil)
    cpdown = CouponDown.new
    cpdown.cid = coupon.id
    cpdown.sid = coupon.shop_id
    cpdown.uid = user_id
    cpdown.dat = Time.now
    cpdown.photo_id = photo_id if photo_id
    cpdown.d_sid = sid if sid && sid != cpdown.sid
    cpdown.num = next_num(coupon.id)
    cpdown.save!
    cpdown.gen_share_coupon_img if coupon.img.blank? && coupon.t2.to_i==2
    cpdown
  end
  
  def use(user_id, data, sid = nil)
    raise "你没有获取这张优惠券" if self.uid!=user_id
    self.uat = Time.now
    self.data = data if data
    self.st = 2
    self.u_sid = sid if sid && sid!=self.sid
    self.save!
  end
  
  def gen_share_coupon_img(gen_seq=true)
    raise "图片分享后才能生成分享类优惠券" unless photo_id
    path = share_coupon_img_path
    return path if File.exist?("public"+path)
    desc = coupon.desc.to_s
    dea = desc.split(/\r\n/)
    dea[4] = "优惠券编号: #{download_num}" if gen_seq
    desc = dea.join("\r\n")

    `cd coupon && ./gen_demo.sh '#{coupon.name}' '#{desc}' ../public#{path} #{Photo.img_url(photo_id, :t2)}`
    return path
  end
  
  def gen_tmp_checkin_coupon_img
    path = share_coupon_img_path
    return path if File.exist?("public"+path)
    `cd coupon && ./gen_tmp.sh '#{self.download_num}' '#{coupon.img.url}' ../public#{path}`
    return path
  end

  #优惠券的下载编号。 优惠券的编号 + 当前下载编号
  def download_num
    "#{coupon.num}-#{num.to_s.rjust(3,'0')}"
  rescue
    ""
  end
  
  def share_coupon_img_path
    "/uploads/tmp/cpd_#{self.id}.jpg"
  end

  #优惠券下发后没有收到时间的， 30秒后至3分钟内自动重发
  def self.auto_resend(tim = Time.now)
    self.where({dat: {"$gte" => tim - 180, "$lte" => tim - 30}, sat: nil, uat: nil }).each do |cpd|
      cpd.xmpp_send
    end
  end
  
  def xmpp_send
    if ENV["RAILS_ENV"] == "production"
      Xmpp.send_chat("scoupon",self.uid,self.message, self.id, " seq='#{self.download_num}' ")  
      return true
    else
      return Xmpp.chat("scoupon",self.uid,self.message, self.id, " seq='#{self.download_num}' ") 
    end
  end

  
  def output_hash
    hash = {id:_id, dat:d_date, uat: u_date, seq:download_num, name:coupon.name, shop:shop.name, shop_id:shop.id, status:self.status}
    hash.merge!( {hint:coupon.hint} ) if coupon.hint
    hash
  end


  #听说分享有礼手动发送优惠券
  def self.ting_shuo_fen_xiang_you_li
    coupon_ids = ["521717fd20f3186318000010", "5217185720f31885bf000003", "521718e120f3186318000014", "5217165720f318ab8a00000f",
      "521718a020f3186318000012", "5217193020f318ab8a000012", "521714e120f318631800000c"]
    users = ["52134bc1c90d8b05da000001", "5212d611c90d8b99ae000005", "5210c7b3c90d8b527e000001", "51d62e51c90d8b81d0000033",
      "51dda3cdc90d8b811a000004", "5212c541c90d8b1ef4000001", "51f48e43c90d8b424d000001", "51d6b618c90d8b5ad600012e",
      "51d656c6c90d8b5ad6000073", "5215f462c90d8ba0a6000004", "5215fd66c90d8b020c000006", "51e16de3c90d8b672200024d", "51da1894c90d8b69be000001", '502e6303421aa918ba000007']
    coupon_ids.each do |cid|
      users.each {|uid|  CouponDown.download(Coupon.find(cid), uid)}
    end
  end
  
  def self.init_status
    CouponDown.where({uat:{"$exists" => true}, st:{"$exists" => false} }).each{|cd| cd.set(:st, 2)}
    #TODO: 一个月以前未使用的优惠券，设置st=4
  end
  
end





