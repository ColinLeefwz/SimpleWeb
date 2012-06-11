class User < ActiveRecord::Base

  has_one :user_logo


  def self.auth(name,password)
    admin = self.find_by_name(name)
    if admin
      if admin.password != password
        admin = nil
      end
    end
    admin
  end

  def logo
    if user_logo
      user_logo.avatar.url
    end
  end
  
  def safe_output
    self.attributes.slice("id", "name", "wb_uid", "gender", "birthday").merge!( {:logo => logo} )
  end


end
