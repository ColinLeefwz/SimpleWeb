# encoding: utf-8

class WeiboFriend
  @queue = :normal

  def self.perform(token, wb_uid, uid)
    data = SinaFriend.new.insert_ids(wb_uid,token)
    user = User.find(uid)
    friend_notice_all(user)
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
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
end