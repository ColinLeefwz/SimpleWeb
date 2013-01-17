# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid)
    xmpp = Xmpp.chat(uid,"502e6303421aa918ba000001","新用户来了")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
end