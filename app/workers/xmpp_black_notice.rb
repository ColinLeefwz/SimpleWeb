# encoding: utf-8

class XmppBlackNotice
  @queue = :xmpp

  def self.perform(uid,bid)
    bu = User.find(bid)
    xmpp = Xmpp.chat($gfuid, uid,": 您好！您对#{bu.name}的举报我们已经收到，在调查清楚后会立刻处理。谢谢您对脸脸的支持！")
    RestClient.post("http://#{$xmpp_ip[1]}:5280/rest", xmpp) 
  end
end