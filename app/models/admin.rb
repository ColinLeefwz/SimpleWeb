class Admin < ActiveRecord::Base
  has_and_belongs_to_many :roles
  belongs_to :depart
  
  validates_presence_of :name, :password
  validates_uniqueness_of :name
  validates_confirmation_of :password

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
