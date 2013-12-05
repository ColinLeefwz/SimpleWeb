# encoding: utf-8
#新用户注册时， 获取关注列表，如果关注的人有脸脸注册， 通知注册用户。
#                      获取粉丝列表， 如果粉丝的人有脸脸注册，通知粉丝。


class WeiboUserNotice
  @queue = :normal

  
  def self.perform(uid)
    return if (user = User.find_by_id(uid)).nil?
    return if user.wb_uid.blank?
    token = $redis.get("wbtoken#{uid}")
    send_friend_notice(user, token)
  end



  def self.send_follow_notice(user, token)
    api = "https://api.weibo.com/2/friendships/followers/ids.json"
    get_friendships(api, user, token).each do |u|
      Xmpp.send_chat(user.id, u.id, "我是你微博关注的人‘#{user.wb_name}’,也在使用脸脸，要来关注我哦！")
    end

    #TODO 
  end


  def self.send_friend_notice(user, token)
    api = "https://api.weibo.com/2/friendships/friends/ids.json"
    get_friendships(api, user, token).each do |u|
      Xmpp.send_chat(u.id, user.id, "我是你微博关注的人‘#{user.wb_name}’也在使用脸脸，要来关注我哦！")
    end
  end

  def self.get_friendships(api, user, token )
    response = res_api(api, user, token)
    return if respone.nil?
    ids = response['ids']
    total_number = response['total_number']
    (total_number/500).times do |t|
      begin
        response = res_api(api, user, token,(t+1)*500 )
        ids = ids+response['ids']
      rescue
        next
      end
    end
    User.where({wb_uid: {"$in" => ids}})
  end

  def self.res_api(api, user, token, cursor=0, err=0)
    begin
      JSON.parse(RestClient.get("#{api}?uid=#{user.wb_uid}&access_token=#{token}&count=#{500}&cursor=#{cursor}"))
    rescue RestClient::BadRequest
      return nil
    rescue
      return nil if (err += 1) > 3
      res_api(api, user, token, cursor, err)
    end
  end
  
end