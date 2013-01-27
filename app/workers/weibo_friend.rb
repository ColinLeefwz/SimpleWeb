# encoding: utf-8

class WeiboFriend
  @queue = :normal

  def self.perform(token, wb_uid, uid)
    data = SinaFriend.new.insert_ids(wb_uid,token)
    user = User.find(uid)
    user.sina_friends_not_lianlian_friends.each do |x|
      WeiboFriend.friend_notice(user,x)
    end
  end
  
  def self.friend_notice(user,x)
    xmpp = Xmpp.chat(x.id,user.id,": 您的微博好友#{x.wb_name}也在使用脸脸，也在脸脸中加TA为好友吧。")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
end