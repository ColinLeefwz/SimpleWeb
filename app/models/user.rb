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

  field :tk  #Push消息的token
  field :city
  
  field :blacks, type:Array #黑名单
  field :follows, type:Array #关注

  validates_uniqueness_of :wb_uid #TODO: 是否name必须唯一，以及添加其它约束
  
  index({"blacks.report" => 1},{ sparse: true })
  index({wb_uid: 1})
  index({follows: 1})
  index({city: 1, gender:1})
  
  def follows_s
    (self.follows.nil?)? [] : self.follows
  end
  
  def blacks_s
    (self.blacks.nil?)? [] : self.blacks
  end

  def reports_s
    bs = blacks_s
    bs.blank? ? [] : bs.select{|b| b['report']==1}
  end

  def reported_users
    rs = reports_s
    rs.blank? ? [] : rs.map{|r| User.find_by_id(r["id"])}
  end
  
  # user_id是否在黑名单中
  def black?(user_id)
    match = self.blacks_s.find {|x| x["id"].to_s==user_id.to_s}
    ! match.nil?
  end
  
  #是否屏蔽user_id（该用户的最后出现位置，以及在商家用户列表中找到）
  def block?(user_id)
    return true if self.invisible==2
    return true if black?(user_id)
    return true if self.invisible==1 && !( self.friend?(user_id) or self.follower?(user_id))
    return false
  end
  
  #是否是被封杀的用户
  def forbidden?
    auto!=true && password==nil
  end
  

  def attr_with_id
    hash = self.attributes.merge({id: self._id})
    hash.delete("_id")
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
    UserLogo.find(head_logo_id)
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
    if !head_logo_id.nil?
      #这里使用了一个很trick的优化：直接构造整个UserLogo对象,可以少一次数据库查询。
      logo = UserLogo.new
      logo._id = head_logo_id
      logo.img_filename = "0.jpg"
      logo.logo_thumb_hash
    else
      {:logo => "", :logo_thumb => "", :logo_thumb2 => ""}
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
  
  def safe_output
    hash = self.attributes.slice("name", "signature", "wb_uid", "wb_v", "wb_vs", "gender", "birthday", "logo", "job", "jobtype","pcount")
    hash.merge!({id: self._id}).merge!( head_logo_hash)
  end
  
  def safe_output_with_relation( user_id )
    if user_id.nil?
      safe_output
    else
      user_id = User.find(user_id)._id if user_id.class == String
      safe_output.merge!( relation_hash(user_id) )
    end
  end
  
  def output_with_relation( user_id )
    hash = self.attr_with_id
    hash.delete("password")
    hash.delete("blacks")
    hash.delete("follows")
    hash.merge!( head_logo_hash).merge!( relation_hash(user_id) )
    hash.merge!(last_location(user_id))
  end

  #当前用户的最后位置。 user_id 是查看当前用户的user
  def last_location( user_id )
    return {:last => "隐身"} if block?(user_id)
    loc = last_loc
    return {:last => ""} if loc.nil?
    diff = Time.now.to_i - loc.cati
    tstr = User.time_desc(diff)
    dstr = Shop.find(loc.sid).name if dstr.nil?
    {:last => "#{tstr} #{dstr}"}
  end
  
  def last_loc
    loc = Checkin.where({uid:self._id}).sort({_id:1}).last
  end
  
  def relation_hash( user_id )
    {:friend => follower?(user_id), :follower => friend?(user_id)}
  end
  
  def friend?(user_id)
    self.follows !=nil && self.follows.index(user_id) !=nil
  end
  
  def follower?(user_id)
    begin
      return User.find(user_id).follows.index(self._id) !=nil
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
    SinaFriend.where({"data.ids" => wb_uid}).map {|x| User.where({wb_uid:x.id}).first}
  end
  
  def sina_fans_not_lianlian_fans
    sina_fans.delete_if {|x| x.follows_s.index(self.id)!=nil }
  end
  
  def del_test_user
    user_logos.each {|x| x.delete}
    photos.each {|x| x.delete}
    Checkin.where({uid: _id}).each {|x| x.delete}
    self.delete
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
      shop = Shop.find(shop.id).name unless shop.nil?
      puts "#{x.id}, #{x.name}, #{x.wb_uid},\t #{u.name}, #{u.wb_uid}, #{shop}"
    end
    ret
  end

end
