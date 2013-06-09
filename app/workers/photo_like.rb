# encoding: utf-8
require 'user'
class PhotoLike
  @queue = :normal

  def self.perform(photo_id, gender)
    uid = (gender.to_i == 2 ? $fakeusers1 : $fakeusers2).sample
    $redis.zadd("Like#{photo_id}", Time.now.to_i, uid)
  rescue
    nil
  end
  
end