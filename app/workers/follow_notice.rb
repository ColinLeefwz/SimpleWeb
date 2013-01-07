# encoding: utf-8

class FollowNotice
  @queue = :xmpp

  def self.perform(user,tid,location)
    xmpp = Xmpp.chat(user.id,tid,"# #{user.name}在#{location}看到并关注了你噢~")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
end