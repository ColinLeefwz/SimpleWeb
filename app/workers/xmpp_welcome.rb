# encoding: utf-8

class XmppWelcome
  @queue = :xmpp

  def self.perform(sid,message,uid)
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => sid , :message=> message ,
        :uid => uid)  {|response, request, result| puts response }
    #TODO: 处理rest调用出错和重试
    #TODO: 消息持久化。目前是直接投递的，导致没有保存。
  end
end