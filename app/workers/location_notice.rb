# encoding: utf-8

class LocationNotice
  @queue = :normal

  def self.perform(uid,sid)
    user = User.find_by_id(uid)
    shop = Shop.find_by_id(sid)
    same_location(uid,sid,user,shop)
    user.notify_good_friend(shop) #好友在一个小时内，在距离2公里以内的其他地点签到过
  end
  
  #提醒的条件：
  #一小时内在同一地点签到过的
  #三小时内在同一地点签到过的，且是最后一次签到的
  #关注我的人在同一个地点签到过的
  # TODO: 如果是android设备，如何push提醒
  def self.same_location(uid,sid,user,shop)
    now = Time.now.to_i
    $redis.zrangebyscore("UA#{sid.to_i}", now-3600*3, now, withscores:true).each do |id, time|
      next if uid==id
      if (now - time) < 3600
        push(id,user,shop)
      else
        arr = User.last_loc_cache(id)
        next if arr.nil? || arr.size<3
        next if shop.name!=arr[1] #不在同一个地点
        push(id,user,shop)
      end
    end
    uids = $redis.zrangebyscore("UA#{sid.to_i}", 0, now-3600*3）
    uids.each do |id|
      #
    end
  end
  
  def self.push(id,user,shop)
    token = User.find_by_id(id).tk
    next unless token
    Resque.enqueue(PushMsg, token,
     "#{user.name}刚刚摇了摇手机进入#{shop.name}了！")
  end
  
end
