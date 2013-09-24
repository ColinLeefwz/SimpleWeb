# encoding: utf-8

class XmppRoomMsg2
  @queue = :xmpp
  
  def self.perform(room, uid, msg, mid=nil, log=0)
    mid = $uuid.generate if mid.nil?
    Xmpp.post("api/room", :roomid  => room , :message=> msg , :uid => uid, :mid => mid, :log => log)
  end
  
end