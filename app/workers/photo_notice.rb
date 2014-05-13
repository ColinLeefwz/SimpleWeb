# encoding: utf-8

class PhotoNotice
  @queue = :normal

  def self.perform(pid)
    photo = Photo.find_primary(pid)
    user = photo.user
    uid = user.id
    shop = photo.shop
    Rails.cache.fetch("PhotoRoom#{uid}", :expires_in => 30.minutes) do
      same_location_realtime(user.id, shop.id, user, shop)
    end
    return if Os.overload?(0.9)
    return if $redis.sismember("UnBroadcast", shop.id.to_s)
    user.fans.each do |u|
      next if u.id.to_s == $gfuid
      str = "[img:#{pid}]#{photo.total_str}"
      str += "#{photo.desc}" unless photo.desc.nil?
      shop = photo.shop
      Resque.enqueue(XmppMsg, user.id, u.id, str, "FEED#{pid}#{u.id}", " NOLOG='1' NOPUSH='1' SID='#{shop.id}' SNAME='#{shop.name}' ", "<x xmlns='dface.shop' SID='#{shop.id}' SNAME='#{shop.name}' ></x>#{photo.thumb2_urls}#{photo.photos_urls}")
    end
  end

  def self.same_location_realtime(uid,sid,user,shop)
    now = Time.now.to_i
    $redis.zrangebyscore("UA#{sid.to_i}", now-3600*2, now).each do |id|
      next if uid.to_s==id.to_s
      next if id.to_s == $gfuid
      arr = User.last_loc_cache(id)
      next if arr.nil? || arr[1] != shop.name
      push(id,user,shop)
    end
    now
  end
  

  def self.push(id,user,shop)
    user = User.find_by_id(id)
    token = user.tk
    return unless token
    Resque.enqueue(PushMsg, token, "",
     "#{user.name}在#{shop.name}分享了照片，快去看看吧",id)
  end
    
end
