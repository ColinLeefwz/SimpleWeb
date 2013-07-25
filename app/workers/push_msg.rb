# encoding: utf-8

class PushMsg
  @queue = :normal

  def self.perform(token, msg, type="push")
    msg = msg[0,18] + "..." if msg.bytesize>80
    Xmpp.post("api/push", :token => token, :txt => msg)
  end
  
end