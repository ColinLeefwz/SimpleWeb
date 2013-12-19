# encoding: utf-8

class XmppRoomMsg
  @queue = :xmpp

  def self.perform(from,room,to,msg,id=nil, attrs="", ext="")
    Xmpp.send_gchat2(from,room,to,msg, id, attrs, ext)
  end
  
end