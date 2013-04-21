# coding: utf-8

class UserFollow
  include Mongoid::Document
  field :follows, type:Array #关注
  
  def self.find_or_new(uid)
    uf = UserFollow.find_by_id(uid)
    if uf.nil?
      uf = UserFollow.new
      uf.id = uid
      uf.follows = []
      uf.save!
    end
    uf
  end
  
  def self.add(uid,fid)
    uf = UserFollow.find_or_new(uid)
    uf.add_to_set(:follows, fid)
    uf.del_my_cache
    Rails.cache.delete("UI#{fid}#{uid}")
  end
  
  def self.del(uid,fid)
    uf = UserFollow.find(uid)
    uf.pull(:follows,fid)
    uf.del_my_cache
    Rails.cache.delete("UI#{fid}#{uid}")
  end
  
end