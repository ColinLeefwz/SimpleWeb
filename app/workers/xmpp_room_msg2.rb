# encoding: utf-8

class XmppRoomMsg2
  @queue = :xmpp
  
  def self.perform(room, uid, msg)
    RestClient.post("http://#{$xmpp_ip[1]}:5280/api/room", 
        :roomid  => room , :message=> msg , :uid => uid)
  end
  
end