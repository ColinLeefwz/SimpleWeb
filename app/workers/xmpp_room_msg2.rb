# encoding: utf-8

class XmppRoomMsg2
  @queue = :xmpp
  
  def self.perform(room, uid, msg)
    Xmpp.post("api/room", :roomid  => room , :message=> msg , :uid => uid)
  end
  
end