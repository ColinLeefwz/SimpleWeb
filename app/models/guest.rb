# coding: utf-8
class Guest
  include Mongoid::Document
  field :_id, type: Integer
  field :name 
  field :password
  field :desc

  def self.auth(id, pass)
  	guest = Guest.find_by_id(id)
    return guest if guest && guest.password == pass
  end

end