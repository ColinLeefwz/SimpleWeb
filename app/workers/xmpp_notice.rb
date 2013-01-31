# encoding: utf-8

class XmppNotice
  @queue = :xmpp

  def self.perform(sid,uid,str)
    Xmpp.send_gchat(sid,uid,str)
  end
  
end