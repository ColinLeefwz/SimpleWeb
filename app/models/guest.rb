# coding: utf-8
class Guest
  include Mongoid::Document
  field :name 
  field :password
  field :desc

  def self.auth(name, pass)
  	guest = Guest.where({name: name}).first
    return guest if guest && guest.password == pass
  end

end