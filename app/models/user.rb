# coding: utf-8

class User 
  include Mongoid::Document
  field :wb_uid #微博uid
  field :wb_v, type:Boolean #是否是微博认证用户
  field :wb_vs # 微博认证说明
  field :name # 昵称，最多10个字符
  field :gender, type: Integer #性别
  field :birthday #生日
  field :password #密码
  field :invisible, type: Integer #隐身模式，1对陌生人隐身，2对所有人隐身
  field :signature #签名
  field :job #职业说明
  field :jobtype, type: Integer #职业类别
  field :hobby #爱好
  field :multip, type:Boolean, default:false #该用户是否上传了多张图片
  field :pcount, type: Integer #上传的头像的数量
  field :head_logo_id, type: Moped::BSON::ObjectId
  
  field :blacks, type:Array #黑名单
  field :follows, type:Array #关注

  validates_uniqueness_of :wb_uid #TODO: 是否name必须唯一，以及添加其它约束
  
  def self.find2(id) #和find相比不抛出异常
    begin
      User.find(id)
    rescue
      nil
    end
  end
  
  def follows_s
    (self.follows.nil?)? [] : self.follows
  end
  
  def blacks_s
    (self.blacks.nil?)? [] : self.blacks
  end

  def reports_s
    bs = blacks_s
    bs.blank? ? [] : bs.select{|b| b['report']}
  end

  def reported_users
    rs = reports_s
    rs.blank? ? [] : rs.map{|r| User.find(r["id"])}
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
  

  def attr_with_id
    hash = self.attributes.merge({id: self._id})
    hash.delete("_id")
    hash
  end

  def user_logos
    return [] unless self._id
    UserLogo.logos(self._id)
  end

  
  def head_logo
    return nil if head_logo_id.nil?
    #UserLogo.find(head_logo_id)
    #这里使用了一个很trick的优化：只需要知道logo的id就可以构造整个UserLogo对象。可以少一次数据库查询。
    UserLogo.new({_id:head_logo_id,img_filename: "0.jpg"})
  end
  
  def head_logo_hash
    if !head_logo_id.nil?
      head_logo.logo_thumb_hash
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
    hash = self.attributes.slice("name", "signature", "wb_uid", "wb_v", "wb_vs", "gender", "birthday", "logo", "job", "jobtype", "multip","pcount")
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

  def last_location( user_id )
    return {:last => "隐身"} if block?(user_id)
    loc = Checkin.where({uid:self._id}).sort({_id:1}).last
    return {:last => ""} if loc.nil?
    diff = Time.now.to_i - loc.cat.to_i
    tstr = User.time_desc(diff)
    dstr = Shop.find(loc.sid).name if dstr.nil?
    {:last => "#{tstr} #{dstr}"}
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

  def is_staff?
    !Staff.where({user_id: id}).empty?
  end
  
end
