# encoding: utf-8

class NewUserWelcome
  @queue = :normal

  def self.perform(uid,sid,seq)
    user = User.find(uid)
    shop = Shop.find(sid)
    if seq==1
      gstr = user.gender==2? "美女" : "帅哥"
      xmpp1 = Xmpp.chat($gfuid,user.id,"hi，#{user.name}，脸脸在#{shop.name}发现了你，是个#{gstr}噢😊！")
      RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp1)
    end
    if seq==2
      xmpp2 = Xmpp.chat($gfuid,user.id,"你就这么很有缘的成为了脸脸早期体验者，俗话说：先入山门为大。以后来到#{shop.name}的小辈们都会向你膜拜哟！")
      RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2)
    end
    if seq==3
      xmpp3 = Xmpp.chat($gfuid,user.id,"有兴趣的话可以参与脸脸#{shop.city_name}种子计划，有特权的啦！了解详情请回复1")
      RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp3)
    end
  end
  
end