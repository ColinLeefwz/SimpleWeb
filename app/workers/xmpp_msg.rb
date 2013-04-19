# encoding: utf-8

class XmppMsg
  @queue = :xmpp

  def self.perform(from,to,msg, id=nil)
    Xmpp.send_chat(from,to,msg, id)
  end
  
end