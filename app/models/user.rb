# coding: utf-8

class User 
  include Mongoid::Document
  #field :_id, type: Integer
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


  def attr_with_id
    hash = self.attributes.merge({id: self._id})
    hash.delete("_id")
    hash
  end

  def user_logos
    return [] unless self._id
    UserLogo.where("user_id='#{self._id}'").order("ord asc")
  end

  
  def head_logo
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
    hash = self.attr_with_id.slice("name", "wb_uid", "gender", "birthday", "logo")
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
    hash.merge!(last_location)
  end

  def last_location
    loc = Checkin.where({user_id:self._id}).sort({_id:1}).last
    return {:last => ""} if loc.nil?
    diff = Time.now.to_i - loc.cat.to_i
    tstr = case diff
    when 0..60 then "1分钟内"
    when 61..3600 then "#{diff/60}分钟内"
    when 3601..86400 then "#{diff/3600}小时内"
    else "1天以前"
    end
    dstr = loc.shop_name
    dstr = Shop.find(loc.shop_id).name if dstr.nil?
     #TODO: 使用redis保存用户最后出现的地点和时间
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


end
