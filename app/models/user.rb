class User < ActiveRecord::Base


  def self.auth(name,password)
    admin = self.find_by_name(name)
    if admin
      if admin.password != password
        admin = nil
      end
    end
    admin
  end
  
  def safe_output
    self.attributes.slice("id", "name", "wb_uid", "gender", "birthday").merge!( {:logo => '/phone2/images/namei2.gif'} )
  end


end
