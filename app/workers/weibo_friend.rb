# encoding: utf-8

class WeiboFriend
  @queue = :normal
  PAGECOUNT=500

  def self.perform(token, wb_uid, uid)
    user = User.find_by_id(uid)
    user = User.find_primary(uid) if user.nil?
    return if user.nil?    
    send_follow_notice(user, token)
    send_friend_notice(user, token)
  end
  
  def self.send_follow_notice(user, token)
    api = "https://api.weibo.com/2/friendships/followers/ids.json"
    name = user.wb_name
    name = user.name if name.blank?
    attrs = " NOLOG='1' "
    ext = nil
    url = "dface://scheme/user/info?id=#{user.id}"
    attrs += " url='#{url}' "
    ext = "<x xmlns='dface.url'>#{url}</x>"
    get_friendships(api, user, token).to_a.each do |u|
      Xmpp.send_chat(user.id, u.id, ": 您的微博好友#{name}也在使用脸脸，在脸脸中也加TA为好友吧。", nil, attrs, ext )
    end
  end


  def self.send_friend_notice(user, token)
    api = "https://api.weibo.com/2/friendships/friends/ids.json"
    get_friendships(api, user, token).to_a.each do |u|
      name = u.wb_name
      name = u.name if name.blank?
      attrs = " NOLOG='1' "
      ext = nil
      url = "dface://scheme/user/info?id=#{u.id}"
      attrs += " url='#{url}' "
      ext = "<x xmlns='dface.url'>#{url}</x>"
      Xmpp.send_chat(u.id, user.id, ": 您的微博好友#{name}也在使用脸脸，在脸脸中也加TA为好友吧。", nil, attrs, ext)
    end
  end

  def self.get_friendships(api, user, token )
    response = res_api(api, user, token)
    return if response.nil?
    ids = response['ids']
    total_number = response['total_number']
    (total_number.to_i/PAGECOUNT).times do |t|
      begin
        response = res_api(api, user, token,(t+1)*PAGECOUNT )
        ids = ids+response['ids']
      rescue
        next
      end
    end
    User.where({wb_uid: {"$in" => ids.map{|m| m.to_s}}})
  end

  def self.res_api(api, user, token, cursor=0, err=0)
    begin
      JSON.parse(RestClient.get("#{api}?uid=#{user.wb_uid}&access_token=#{token}&count=#{PAGECOUNT}&cursor=#{cursor}"))
    rescue RestClient::BadRequest
      return nil
    rescue
      return nil if (err += 1) > 3
      res_api(api, user, token, cursor, err)
    end
  end


  # def self.fan_notice_all(user)
  #   user.sina_fans_not_lianlian_fans.each do |x|
  #     WeiboFriend.friend_notice(x,user)
  #   end
  # end
  
  # def self.friend_notice_all(user)
  #   user.sina_friends_not_lianlian_friends.each do |x|
  #     WeiboFriend.friend_notice(user,x)
  #   end
  # end
  
  # def self.friend_notice(user,x)
  #   name = x.wb_name
  #   name = x.name if name.nil?
  #   Xmpp.send_chat(x.id,user.id,": 您的微博好友#{name}也在使用脸脸，在脸脸中也加TA为好友吧。")
  # end
end