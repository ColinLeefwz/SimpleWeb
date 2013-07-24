# encoding: utf-8

class WeiboFriend
  @queue = :normal

  def self.perform(token, wb_uid, uid)
    begin
      SinaFriend.new.insert_ids(wb_uid,token)
    rescue
    end
    user = User.find_by_id(uid)
    user = User.find_primary(uid) if user.nil?
    friend_notice_all(user)
    fan_notice_all(user)
  end
  
  def self.fan_notice_all(user)
    user.sina_fans_not_lianlian_fans.each do |x|
      WeiboFriend.friend_notice(x,user)
    end
  end
  
  def self.friend_notice_all(user)
    user.sina_friends_not_lianlian_friends.each do |x|
      WeiboFriend.friend_notice(user,x)
    end
  end
  
  def self.friend_notice(user,x)
    name = x.wb_name
    name = x.name if name.nil?
    xmpp = Xmpp.chat(x.id,user.id,": 您的微博好友#{name}也在使用脸脸，在脸脸中也加TA为好友吧。")
    RestClient.post("http://#{$xmpp_ip[1]}:5280/rest", xmpp) 
  end
end