# encoding: utf-8

class XmppWelcome
  @queue = :xmpp

  def self.perform(sid,user_gender,uid,user_name)
    #直接用resque传递message乱码，我怀疑是resque的问题。
    #Resque.encode("Hi，我来了~😊")
    #=> "\"Hi\\uff0c\\u6211\\u6765\\u4e86~\\uf60a\"" 
    #最后一个字符超过了mbp,应该是\u1f60a
    if user_gender.to_i==2
      message = "'#{user_name}'来了~😊"
    else
      message = "'#{user_name}'来啦~😝"
    end
    
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => sid , :message=> message ,
        :uid => uid)  {|response, request, result| puts response }
    #TODO: 处理rest调用出错和重试
    #TODO: 消息持久化。目前是直接投递的，导致没有保存。
  end
end