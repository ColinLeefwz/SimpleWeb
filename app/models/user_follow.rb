# coding: utf-8

class UserFollow
  include Mongoid::Document
  field :follows, type:Array #关注
  
  def self.find_or_new(uid)
    uf = UserFollow.find(uid)
    if uf.nil?
      uf = UserFollow.new
      uf.id = uid
      uf.follows = []
      uf.save!
    end
    uf
  end
  
end