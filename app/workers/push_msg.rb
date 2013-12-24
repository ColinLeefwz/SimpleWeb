# encoding: utf-8

class PushMsg
  @queue = :normal

  def self.perform(token, name, msg, uid, type="push")
    msg = msg[0,18] + "..." if msg.bytesize>80
    Xmpp.post("api/push", :token => token+name, :uid => uid, :txt => msg)
  end
  
end