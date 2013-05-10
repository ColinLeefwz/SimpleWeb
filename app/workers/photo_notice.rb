# encoding: utf-8

class PhotoNotice
  @queue = :normal

  def self.perform(pid)
    photo = Photo.find_primary(pid)
    user = photo.user
    user.followers.each do |u|
      next if u.id.to_s == $gfuid
      str = ": 推送：#{photo.user.name}刚刚在#{photo.shop.name}分享了一张图片"
      str += ",#{photo.desc}" unless photo.desc.nil?
      Resque.enqueue(XmppMsg, user.id, u.id, str)
      Resque.enqueue(XmppMsg, user.id, u.id, "[img:#{pid}]")
    end
    shop = photo.shop
    same_location_realtime(user.id, shop.id, user, shop)
  end

  def self.same_location_realtime(uid,sid,user,shop)
    now = Time.now.to_i
    $redis.zrangebyscore("UA#{sid.to_i}", now-3600, now).each do |id|
      next if uid==id
      next if id.to_s == $gfuid
      push(id,user,shop)
    end
  end
  

  def self.push(id,user,shop)
    token = User.find_by_id(id).tk
    return unless token
    Resque.enqueue(PushMsg, token,
     "#{user.name}刚刚在#{shop.name}分享了一张照片！")
  end
    
end
