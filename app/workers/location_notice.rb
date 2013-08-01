# encoding: utf-8

class LocationNotice
  @queue = :normal

  def self.perform(uid,sid)
    user = User.find_primary(uid)
    shop = Shop.find_by_id(sid)
    return if shop.lo.nil?
    same_location_realtime(uid,sid,user,shop)
    return if Os.overload?(0.6)
    diff = Time.now.to_i-user.cati
    same_location_fans(uid,sid,user,shop) if diff<3600*240
    same_location_friends(uid,sid,user,shop) if diff<3600*240 
    user.notify_good_friend(shop) #好友在一个小时内，在距离2公里以内的其他地点签到过
  end
  
  #提醒的条件：
  #半小时内在同一地点签到过的
  #三小时内在同一地点签到过的，且是最后一次签到的
  def self.same_location_realtime(uid,sid,user,shop)
    now = Time.now.to_i
    $redis.zrangebyscore("UA#{sid.to_i}", now-3600*3, now, withscores:true).each do |id, time|
      next if uid==id
      next if id.to_s == $gfuid
      if (now - time) < 1800
        push(id,user,shop)
      else
        arr = User.last_loc_cache(id)
        next if arr.nil? || arr.size<3
        next if shop.name!=arr[1] #不在同一个地点
        push(id,user,shop)
      end
    end
  end

  #我签到的地方，我的粉丝以前也去过的，批量通知粉丝
  def self.same_location_fans(uid,sid,user,shop)
    now = Time.now.to_i
    uids = $redis.zrangebyscore("UA#{sid.to_i}", 0, now-3600*3)
    user.fan_not_friend_ids.to_set.intersection(uids).each do |id|
      next if id.to_s == $gfuid
      Resque.enqueue(XmppMsg, uid, id,
       "#{user.name}刚刚摇了摇手机进入你以前也来过的#{shop.name}，打个招呼吧！")
    end
  end
  
  #我签到的地方，我关注的人10天内也来过，通知我
  def self.same_location_friends(uid,sid,user,shop)
    now = Time.now.to_i
    uids = $redis.zrangebyscore("UA#{sid.to_i}", now-3600*24*10, now)
    fs = user.follows.map{|x| x.to_s}.to_set
    couids = fs.intersection(uids)
    return if couids.size==0
    if couids.size > 5
      more = ",...等"
    else
      more = ""
    end
    names = couids.to_a[0,5].map {|id| User.find_by_id(id).name}.join(",")
    Resque.enqueue(XmppNotice, sid, uid, "你的朋友#{names}#{more}也来过这里")
  end
  
  def self.push(id,user,shop)
    token = User.find_by_id(id).tk
    return unless token
    Resque.enqueue(PushMsg, token, "脸脸",
     "#{user.name}也进入#{shop.name}了！", "push_scene")
  end
  
end
