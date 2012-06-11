class User < ActiveRecord::Base
  has_many :user_logos
  
  def latest_logo
    UserLogo.where("user_id=#{self.id}").order("id asc").limit(1)[0]
  end
  
  def latest_logo_hash
    logo = latest_logo
    if logo
      {:logo => logo.avatar.url, :logo_thumb => logo.avatar.url(:thumb) }
    else
      {:logo => "", :logo_thumb => ""}
    end
  end
  
  def safe_output
    self.attributes.slice("id", "name", "wb_uid", "gender", "birthday", "logo").merge!( latest_logo_hash)
  end


end
