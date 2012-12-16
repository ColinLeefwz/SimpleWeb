# encoding: utf-8

class XmppNotice
  @queue = :xmpp

  def self.perform(sid,uid,str)
    xmpp2 = Xmpp.gchat(sid,uid,str)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2) 
  end
end