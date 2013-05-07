# encoding: utf-8

class PhotoNotice
  @queue = :normal

  def self.perform(pid)
    photo = Photo.find_by_id(pid)
    user = photo.user
    user.followers.each do |u|
      str = ": 推送：#{photo.user.name}刚刚在#{photo.shop.name}分享了一张图片"
      str += ",#{photo.desc}" unless photo.desc.nil?
      Resque.enqueue(XmppMsg, user.id, u.id, str)
      Resque.enqueue(XmppMsg, user.id, u.id, "[img:#{pid}]")
    end
  end
  
end
