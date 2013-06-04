# encoding: utf-8

class PhotoNotice
  @queue = :normal

  def self.perform(pid)
    photo = Photo.find_primary(pid)
    user = photo.user
    uid = user.id
    user.fans.each do |u|
      next if u.id.to_s == $gfuid
      str = ": #{photo.user.name}在#{photo.shop.name}分享了一张图片"
      str += ",#{photo.desc}" unless photo.desc.nil?
      if Rails.cache.read("PhotoFan#{uid}")
        Resque.enqueue(XmppMsg, user.id, u.id, str, "NOPUSH#{$uuid.generate}", " NOLOG='1' ")
      else
        Resque.enqueue(XmppMsg, user.id, u.id, str,$uuid.generate," NOLOG='1' ")  
        Rails.cache.write("PhotoFan#{uid}", 1, :expires_in => 8.hours)      
      end
      Resque.enqueue(XmppMsg, user.id, u.id, "[img:#{pid}]", "NOPUSH#{$uuid.generate}", " NOLOG='1' ")
    end
    shop = photo.shop
    Rails.cache.fetch("PhotoRoom#{uid}", :expires_in => 2.hours) do
      #same_location_realtime(user.id, shop.id, user, shop)
    end
  end

  def self.same_location_realtime(uid,sid,user,shop)
    now = Time.now.to_i
    $redis.zrangebyscore("UA#{sid.to_i}", now-3600, now).each do |id|
      next if uid==id
      next if id.to_s == $gfuid
      push(id,user,shop)
    end
    now
  end
  

  def self.push(id,user,shop)
    token = User.find_by_id(id).tk
    return unless token
    Resque.enqueue(PushMsg, token,
     "#{user.name}在#{shop.name}分享了一张照片")
  end
    
end
