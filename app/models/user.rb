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
      safe_output.merge!( {:friend => follower?(user_id), :follower => friend?(user_id)} )
    end
  end
  
  def friend?(user_id)
    Follow.find_by_user_id_and_follow_id(self.id, user_id) !=nil
  end
  
  def follower?(user_id)
    Follow.find_by_user_id_and_follow_id(user_id,self.id) !=nil
  end


end
