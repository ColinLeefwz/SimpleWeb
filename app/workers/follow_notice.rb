# encoding: utf-8

class FollowNotice
  @queue = :xmpp

  def self.perform(user,tid,location)
    name = user["name"]
    xmpp = Xmpp.chat(user["_id"],tid,": #{name}在#{location}看到并关注了你噢~")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
end
