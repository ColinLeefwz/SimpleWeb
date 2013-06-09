# encoding: utf-8
require 'user'
class PhotoLike
  @queue = :normal

  def self.perform(photo_id)
    photo = Photo.find(photo_id)
    uid = (photo.user.gender.to_i == 2 ? $fakeusers1 : $fakeusers2).sample
    $redis.zadd("Like#{photo.id}", Time.now.to_i, uid)
  rescue
    nil
  end
  
end