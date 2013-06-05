# encoding: utf-8
require 'user'
class PhotoLike
  @queue = :normal

  def self.perform(photo)
    user = (photo.user.gender.to_i == 2 ? $fakeusers1 : $fakeusers2).sample
    like = {id: user.id, name: user.name, t: Time.now}
    photo.push(:like, like)
  end
  
end