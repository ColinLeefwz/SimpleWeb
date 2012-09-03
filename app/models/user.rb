# coding: utf-8

class User 
  include Mongoid::Document
  field :wb_uid
  field :name
  field :gender, type: Integer
  field :birthday
  field :password
  field :invisible, type: Integer
  field :signature
  field :job 
  field :jobtype, type: Integer
  field :hobby
  
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
    bs.blank? ? [] : bs.select{|b| b['report']==1}
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
    return true if black?(user_id)
    return true if self.invisible==2
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
    # UserLogo.where({user_id: self._id}).sort({ord:1})
    # 太变态了，sort单独调用可以排序，结合first却无效，只能用order_by
    UserLogo.where({user_id: self._id}).order_by([:ord,:asc])
  end

  
  def head_logo
    return nil if self.user_logos.size==0
    self.user_logos.first
  end
  
  def head_logo_hash
    logo = head_logo
    if logo
      logo.logo_thumb_hash
    else
      {:logo => "", :logo_thumb => "", :logo_thumb2 => ""}
    end
  end
  
  def safe_output
    hash = self.attributes.slice("name", "wb_uid", "gender", "birthday", "logo")
    hash.merge!({id: self._id}).merge!( head_logo_hash)
  end
  
  def safe_output_with_relation( user_id )
    if user_id.nil?
      safe_output
    else
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
    return {:last => ""} if block?(user_id)
    loc = Checkin.where({user_id:self._id}).sort({_id:1}).last
    return {:last => ""} if loc.nil?
    diff = Time.now.to_i - loc.cat.to_i
    tstr = User.time_desc(diff)
    dstr = Shop.find(loc.shop_id).name if dstr.nil?
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


end
