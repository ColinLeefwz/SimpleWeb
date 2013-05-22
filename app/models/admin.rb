class Admin
  include Mongoid::Document
  field :name
  field :password

  validates_length_of :name, :maximum => 32
  validates_length_of :password, :within => 3..32
  validates_presence_of :name, :password
  validates_uniqueness_of :name
  validates_confirmation_of :password

  def self.auth(name,password)
    admin = self.where({name: name}).first
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

  def self.noright
    noright_ids=self.all.only(:_id).map{|m| m._id} - Right.all.only(:_id).map{|m| m._id}
    self.find_by_id(noright_ids)
  end

end
