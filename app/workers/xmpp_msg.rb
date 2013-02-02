# encoding: utf-8

class XmppMsg
  @queue = :xmpp

  def self.perform(from,to,msg)
    Xmpp.send_chat(from,to,msg)
  end
  
end