# encoding: utf-8

class XmppNotice
  @queue = :xmpp

  def self.perform(sid,uid,str,id=nil,attrs="")
    Xmpp.send_gchat(sid,uid,str,id,attrs)
  end
  
end