# encoding: utf-8

class XmppRoomMsg
  @queue = :xmpp

  def self.perform(from,room,to,msg)
    Xmpp.send_gchat2(from,room,to,msg)
  end
  
end