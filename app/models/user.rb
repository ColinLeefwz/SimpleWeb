# coding: utf-8

class User < ActiveRecord::Base
  has_many :user_logos, :order => 'ord asc'
  validates_uniqueness_of :wb_uid

  validates_length_of :name, :maximum => 64
  validates_length_of :wb_uid, :maximum => 64
  validates_length_of :birthday, :maximum => 32
  validates_length_of :password, :maximum => 32
  
  
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
    self.attributes.slice("id", "name", "wb_uid", "gender", "birthday", "logo").merge!( head_logo_hash)
  end
  
  def safe_output_with_relation( user_id )
    if user_id.nil?
      safe_output
    else
      safe_output.merge!( relation_hash(user_id) )
    end
  end
  
  def output_with_relation( user_id )
    hash = self.attributes
    hash.delete("password")
    hash.merge!( head_logo_hash).merge!( relation_hash(user_id) )
    hash.merge!(last_location)
  end

  def last_location
    loc = Checkin.where({user_id:self.id}).sort({_id:1}).last
    diff = Time.now.to_i - loc.cat.to_i
    tstr = case diff
    when 0..60 then "1分钟内"
    when 61..3600 then "#{diff/60}分钟内"
    when 3601..86400 then "#{diff/3600}小时内"
    else "1天以前"
    end
    dstr = loc.shop_name
    dstr = Shop.find(loc.mshop_id).name if dstr.nil?
     #TODO: 使用redis保存用户最后出现的地点和时间
    {:last => "#{tstr} #{dstr}"}
  end
  
  def relation_hash( user_id )
    {:friend => follower?(user_id), :follower => friend?(user_id)}
  end
  
  def friend?(user_id)
    Follow.find_by_user_id_and_follow_id(self.id, user_id) !=nil
  end
  
  def follower?(user_id)
    Follow.find_by_user_id_and_follow_id(user_id,self.id) !=nil
  end


end
