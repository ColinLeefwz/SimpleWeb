# encoding: utf-8
require 'user'
class NewPhoneReg
  @queue = :normal

  def self.perform(uid, phone)
    Group.where({"users.phone" => phone, tat:{"$gt" => Time.now}} ).each do |group|
      group.phone_auth(uid, phone)
    end
  end
  
end