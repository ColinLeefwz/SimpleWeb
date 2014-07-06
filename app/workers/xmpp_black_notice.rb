# encoding: utf-8

class XmppBlackNotice
  @queue = :xmpp

  def self.perform(uid,bid)
    bu = User.find_by_id(bid)
    Xmpp.send_chat($gfuid, uid,": 您好！您对#{bu.name}的举报我们已经收到，在调查清楚后会立刻处理。谢谢您对脸脸的支持！")
  end
end