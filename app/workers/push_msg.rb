# encoding: utf-8

class PushMsg
  @queue = :normal

  def self.perform(token, msg, type="push")
    msg = msg[0,18] + "..." if msg.bytesize>80
    RestClient.post("http://#{$xmpp_ip[1]}:5280/api/push", :token => token, :txt => msg)
  end
  
end