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
      Xmpp.send_gchat2($gfuid,shop.id,user.id,"邀请好友也加入脸脸,看看他们当前都在哪儿，一起玩会更有意思。")
    end
    if seq==4
      #Xmpp.send_chat($gfuid,user.id,"试试回复一个数字0，看看会发生什么！")
    end
  end
  
end