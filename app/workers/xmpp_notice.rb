# encoding: utf-8

class XmppNotice
  @queue = :xmpp

  def self.perform(sid,uid,str,id=nil)
    Xmpp.send_gchat(sid,uid,str,id)
  end
  
end