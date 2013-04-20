# coding: utf-8

class User 
  include Mongoid::Document
  field :wb_uid #微博uid
  field :wb_v, type:Boolean #是否是微博认证用户
  field :wb_vs # 微博认证说明
  field :wb_name
  field :wb_g, type: Integer
  field :name # 昵称，最多10个字符
  field :gender, type: Integer #性别
  field :birthday #生日
  field :password #密码
  field :invisible, type: Integer #隐身模式，1对陌生人隐身，2对所有人隐身
  field :signature #签名
  field :job #职业说明
  field :jobtype, type: Integer #职业类别
  field :hobby #爱好
  field :pcount, type: Integer, default:0 #上传的头像的数量
  field :head_logo_id, type: Moped::BSON::ObjectId
  field :auto, type:Boolean #自动抓取
  field :atime, type:DateTime #自动抓取的微博用户实际注册脸脸的时间
  field :qq
  field :qq_name

  field :tk  #Push消息的token
  field :city
    
  #no_wb_logo: 该用户没有设置新浪微博头像
  #logo_backup: 被禁止的用户，其head_logo_id的备份

  #validates_uniqueness_of :wb_uid #TODO: 是否name必须唯一，以及添加其它约束
  
  index({wb_uid: 1})
  index({city: 1, gender:1})
  
  def follows_s
    follows
  end
  
  def follows
    ret = UserFollow.find_by_id(self.id)
    return [] if ret.nil?
    ret.follows
  end
  
  def blacks_s
    UserBlack.where({uid: self.id})
  end

  def reports_s
    UserBlack.where({uid: self.id, report:1})
  end

  def reported_users
    reports_s.map {|x| User.find_by_id(x["bid"])}
  end
  
  # user_id是否在黑名单中
  def black?(user_id)
    UserBlack.where({uid: self.id, bid: user_id}).first
  end
  
  #是否屏蔽user_id（该用户的最后出现位置，以及在商家用户列表中找到）
  def block?(user_id)
    return true if self.invisible==2 && !self.friend?(user_id)
    return true if black?(user_id)
    return false
  end
  
  #封杀用户
  def kill(del_all_logos=false)
    logo = self.head_logo
    self.update_attribute(:logo_backup, head_logo_id)
    user_logos.each {|x| x.destroy} if del_all_logos
    self.password=nil
    self.head_logo_id=nil
    self.pcount=0
    self.save!
    self.del_my_cache
    RestClient.post("http://#{$xmpp_ip}:5280/api/kill", :user => _id) 
  end
  
  #是否是被封杀的用户
  def forbidden?
    auto!=true && password==nil
  end
  

  def attr_with_id
    hash = self.attributes.merge({id: self._id})
    hash.delete("_id")
    hash.delete("qq")
    hash.merge!({qq_openid: self.qq}) if self.qq
    hash
  end

  def user_logos
    return [] unless self._id
    UserLogo.logos(self._id)
  end
  
  def photos
    Photo.where({user_id:_id})
  end

  
  def head_logo
    return nil if head_logo_id.nil?
    UserLogo.find_by_id(head_logo_id)
  end
  
  def self.check_pcount
    User.all.each do |u|
      if u.pcount != u.user_logos.count
        puts "#{u.name},#{u.pcount},#{u.user_logos.count}"
        u.update_attributes!({"pcount" => u.user_logos.count})
      end
    end
  end
  
  def head_logo_hash
    if head_logo_id.nil?
      {:logo => "", :logo_thumb => "", :logo_thumb2 => ""}
    else
      {:logo => UserLogo.img_url(head_logo_id), 
        :logo_thumb => UserLogo.img_url(head_logo_id, :t1), 
        :logo_thumb2 => UserLogo.img_url(head_logo_id, :t2)}
    end
  end
  
  def self.init_pcount
    User.all.each {|x| x.set(:pcount, x.user_logos.size)}
  end
  
  def self.init_head_logo_id
    User.all.each do |x| 
      ulogo = x.user_logos.first
      next if ulogo.nil?
      x.set(:head_logo_id, ulogo.id)
    end
  end
  
  def safe_output(uid=nil)
    hash = self.attributes.slice("name", "signature", "wb_uid", "wb_v", "wb_vs", "gender", "birthday", "logo", "job", "jobtype","pcount")
    hash.merge!({qq_openid: self.qq}) if self.qq
    hash.merge!({id: self._id}).merge!( head_logo_hash)
  end
  
  def safe_output_with_location( user_id )
    safe_output.merge!( last_location(user_id) )
  end
  
  def output_with_relation( user_id )
    hash = self.attr_with_id
    hash.delete("password")
    hash.delete("follows")
    #TODO: 性能优化
    hash.merge!( head_logo_hash).merge!( relation_hash(user_id) )
    hash.merge!(last_location(user_id))
  end

  #当前用户的最后位置。 user_id 是查看当前用户的user
  def last_location( user_id )
    return {:last => "隐身"} if block?(user_id)
    loc = last_loc
    return {:last => ""} if loc.size==0
    diff = Time.now.to_i - loc[0]
    tstr = User.time_desc(diff)
    dstr = loc[1]
    {:last => "#{tstr} #{dstr}"}
  end
  
  def write_lat_loc(checkin)
    ret = [checkin.cati, checkin.shop.name]
    Rails.cache.write("LASTL:#{self.id}", ret)
    ret
  end

  def last_loc
    Rails.cache.fetch("LASTL:#{self.id}") do
      last_loc_no_cache
    end
  end
    
  def last_loc_no_cache
    ck = Checkin.where({uid:self._id}).sort({_id:1}).last
    ck = [] if ck.nil?
    write_lat_loc(ck)
  end
  
  def relation_hash( user_id )
    {:friend => follower?(user_id), :follower => friend?(user_id)}
  end
  
  def friend?(user_id)
    self.follows.index(user_id) !=nil
  end
  
  def follower?(user_id)
    begin
      return User.find_by_id(user_id).follows.index(self._id) !=nil
    rescue
      return false
    end
  end
  
  def self.time_desc(diff)
    diff=diff.to_i
    case diff
    when 0..60 then "1 min"
    when 61..3600 then "#{diff/60} mins"
    when 3601..7200 then "1 hour"      
    when 7201..86400 then "#{diff/3600} hours"
    when 86401..172800 then "1 day"      
    when 172800..864000 then "#{diff/86400} days"
    else "10+ days"
    end
  end


  def show_gender
    {0=> '未设置', 1 => '男', 2 => '女'}[self.gender.to_i]
  end

  def weibo_home
    "http://www.weibo.com/#{wb_uid}" if wb_uid
  end

  def checkins
    Checkin.where({uid: _id, del: {"$exists" => false}}).sort({_id:-1})
  end

  def is_staff?
    !Staff.where({user_id: id}).empty?
  end
  
  def room_photos
    Photo.where({user_id: _id})
  end

  def chat
    $xmpp_ips.count.times do |t|
      url = "http://#{$xmpp_ips[t]}:5280/api/chat?uid=#{self.id.to_s}"
      begin
        return JSON.parse(RestClient.get(url))
      rescue
        next
      end
    end
  end

  def human_chat(uid)
    $xmpp_ips.count.times do |t|
      url = "http://#{$xmpp_ips[t]}:5280/api/chat2?uid1=#{self.id.to_s}&uid2=#{uid}"
      begin
        return JSON.parse(RestClient.get(url))
      rescue
        next
      end
    end
  end
  
  def merge_to_checkin(cins,photo)
    cins.each do |c|
      if photo.room==c.sid.to_s
        puts c.id.generation_time
        if photo.id.to_s > c.id.to_s
          puts "#{c.sid}\t#{c.id.generation_time} : #{photo.id.generation_time}"
          c.push(:photos, photo.id)
          return
        end
      end
    end
  end

  #足迹功能需要将历史照片合并到签到中去。以后发的照片立刻写入签到中。
  def init_trace
    #checkins = self.checkins.map {|x| x.attributes.slice("_id","sid")}
    cins = self.checkins.only("sid").sort({_id:-1}).to_a
    room_photos.each {|p| merge_to_checkin(cins,p) }
  end
  
  def self.init_trace_all
    User.all.each {|x| x.init_trace}
  end

  def self.city_distribute
    users = User.where({city:{"$exists" => true},auto:{"$exists" => false}})
    user_city = users.group_by{|g| g.city}.map{|k, v| [City.gname(k), v.count]}
    user_city.sort { |a, b| b[1] <=> a[1]  }
  end
  
  def sina_friends
    ret = []
    sf = SinaFriend.find_by_id(wb_uid)
    return [] if sf.nil?
    sf.data["ids"].each do |id|
      user= User.where({wb_uid:id}).first
      ret << user unless user.nil?
    end
    ret
  end

  def sina_friends_not_lianlian_friends
    sina_friends.delete_if {|x| follows_s.index(x.id)!=nil }
  end  
  
  def sina_fans
    fans = SinaFriend.where({"data.ids" => wb_uid}).map {|x| User.where({wb_uid:x.id}).first}
    fans.delete_if {|x| x.nil? }
  end
  
  def sina_fans_not_lianlian_fans
    sina_fans.delete_if {|x| x.follows_s.index(self.id)!=nil }
  end
  
  def del_test_user
    self.del_my_cache
    user_logos.each {|x| x.destroy}
    photos.each {|x| x.destroy}
    Checkin.where({uid: _id}).each {|x| x.destroy}
    self.destroy
  end
  
  
  #目前导入的虚拟帐户被脸脸用户加关注的用户，需要人工联系
  def self.auto_todo
    ret = []
    User.all.each do |u|
      next if u.follows.nil?
      u.follows.map {|x| User.find_by_id(x)}.each do |user|
        next if user.nil?
        ret << [user,u] if user.auto
      end
    end
    ret.each do |arr| 
      x = arr[0]
      u=arr[1]
      shop = ShopSinaUser.where({users:x.id}).first
      shop = Shop.find_by_id(shop.id).name unless shop.nil?
      puts "#{x.id}, #{x.name}, #{x.wb_uid},\t #{u.name}, #{u.wb_uid}, #{shop}"
    end
    ret
  end

  def self.fix_head_logo_err
    fix_head_logo_err1
    fix_head_logo_err2
  end
  
  def self.fix_head_logo_err1(pcount=1000)
    User.where({auto:{"$ne"=>true},head_logo_id:{"$exists"=>true}}).sort({_id:-1}).limit(pcount).each do |u|
      next if u.forbidden?
      logo = UserLogo.find_by_id(u.head_logo_id)
      next if (logo && (Time.now.to_i-logo.id.generation_time.to_i < 60))
      next if (logo && logo.img.url)
      begin
        u.fix_head_logo_err1_do(logo)
      rescue Exception => e
        puts e
      end
    end    
  end
  
  def fix_head_logo_err1_do(logo)
    if logo.nil?
      fix_head_logo_err_nil
    else
      puts "#{name}, 图片未上传到阿里云。"
      begin
       CarrierWave::Workers::StoreAsset.perform("UserLogo",head_logo_id.to_s,"img")
      rescue Errno::ENOENT => e
        puts "#{name}, 图片有数据库记录，但是文件不存在。"
        logo.destroy
        self.update_attribute(:head_logo_id, nil)
        self.update_attribute(:head_logo_id, user_logos.first.id) if user_logos.first.img.url
      end 
    end
  end
  
  def fix_head_logo_err_nil
    if user_logos.count>0
      puts "#{name}, 头像不存在，但是有照片。"
      self.update_attribute(:head_logo_id, user_logos.first.id) if user_logos.first.img.url
      return true
    else
      puts "#{name}, 图片不存在。"
      return false
    end
  end
  
  def self.fix_head_logo_err2
    User.where({auto:{"$ne"=>true},head_logo_id:nil}).sort({_id:-1}).limit(1000).each do |u|
      next if u.forbidden?
      if u.checkins.count==0
        #puts "该用户不活跃"
      else
        next if u.wb_uid.nil?
        next if u.wb_uid.to_i.to_s.size != u.wb_uid.size
        next if u["no_wb_logo"]
        puts "#{u.name},  #{u.id},  #{u.wb_uid}"
        next if u.fix_head_logo_err_nil
        SinaUser.gen_head_logo(u)
      end
    end
  end
  
  def fix_pcount_error
    c = user_logos.count
    self.update_attribute(:pcount,c) if self.pcount!=c
  end
  
  $fakeusers1=["513ebae8c90d8b5e01000082", "513ecdf0c90d8b5901000123", "5141764fc90d8bc67b0002b8", "5141790fc90d8bc67b0002db", "514162e9c90d8bc97b000187", "51417e23c90d8bc37b00048f", "51418783c90d8bc97b000517", "51418836c90d8bc37b000567", "514188d4c90d8bc97b000569", "5141899fc90d8bc97b00056f", "51427b92c90d8b670c00027b", "513e8f16c90d8b9f7d0002be", "513e9311c90d8b0b0a000348", "51428dcfc90d8be76c0004cf"] 
  $fakeusers2=["513ec89cc90d8b5b010000d1", "513ed1e7c90d8b590100016f", "514179b1c90d8bc67b0002fb", "51413535c90d8b681d0004ed", "51413be6c90d8b681d00057d", "51413fd4c90d8b5215000561", "514143dbc90d8b52150005e3", "5141469ec90d8b681d000681", "51415eb0c90d8bc37b0001a0", "51416042c90d8bc97b00014a", "5141667fc90d8bc67b000186", "51417b05c90d8bc37b000473", "51417ee3c90d8bc37b000497", "51417f8cc90d8bc37b00049f", "51418667c90d8bc67b000421", "51418bf7c90d8bc37b0005d2", "514190f8c90d8bc67b00054a", "5141921ec90d8bc97b00069d", "51419a00c90d8bc67b0005b5", "51419b91c90d8bc37b000819", "51419c4cc90d8bc37b000826", "51419db8c90d8bc97b0007bd", "51419ec0c90d8bc97b0007c1", "51419fdbc90d8bc97b0007e7"] 
  
  def self.fake_user(view_by_who)
    if view_by_who.gender==2
      index = (view_by_who.cati+Time.now.mday) % $fakeusers1.size
      uid = $fakeusers1[index]  
    else
      index = (view_by_who.cati+Time.now.mday) % $fakeusers2.size
      uid = $fakeusers2[index]
    end
    User.find_by_id(uid)
  end

end
