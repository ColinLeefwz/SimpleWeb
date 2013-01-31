# encoding: utf-8

class NewUserWelcome
  @queue = :normal

  def self.perform(uid,sid,seq)
    user = User.find(uid)
    shop = Shop.find(sid)
    if seq==1
      gstr = user.gender==2? "美女" : "帅哥"
      Xmpp.send_gchat2($gfuid,shop.id,user.id,"hi，#{user.name}，脸脸在#{shop.name}发现了你，是个#{gstr}噢😊！")
    end
    if seq==2
      Xmpp.send_gchat2($gfuid,shop.id,user.id,"你就这么很有缘的成为了脸脸早期体验者，俗话说：先入山门为大。以后来到#{shop.name}的小辈们都会向你膜拜哟！")
    end
    if seq==3
      Xmpp.send_chat($gfuid,user.id,"回复0了解脸脸使用秘笈，有惊喜哟！")
    end
  end
  
end