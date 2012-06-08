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

  def pass2
    password[0,1]+"***"+password[password.length-1,1]
  end
end
