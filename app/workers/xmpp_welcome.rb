# encoding: utf-8

class XmppWelcome
  @queue = :xmpp

  def self.perform(sid,user_gender,uid,user_name)
    #直接用resque传递message乱码，我怀疑是resque的问题。
    #Resque.encode("Hi，我来了~😊")
    #=> "\"Hi\\uff0c\\u6211\\u6765\\u4e86~\\uf60a\"" 
    #最后一个字符超过了mbp,应该是\u1f60a
    if user_gender.to_i==2
      message = "#{user_name} 来了~😊"
    else
      message = "#{user_name} 来啦~😝"
    end
    
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => sid.to_i.to_s , :message=> message ,
        :uid => uid)
  end
end