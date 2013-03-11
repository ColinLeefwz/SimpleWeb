# encoding: utf-8

class NewUserTalk
  @queue = :normal

  def self.perform(uid,sid,seq)
    user = User.find(uid)
    if user.gender==2
      to = "50bc20fcc90d8ba33600004b" #浦靠谱
    else
      if Time.now.to_i % 2 ==0
        to = "50bec2c1c90d8bd12f000086" #amanda林
      else
        to = "50ffd0e5c90d8bf7480000b7" #沈翌
      end
    end
    if seq==1
      xmpp1 = Xmpp.chat(to,uid,"hi")
      RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp1)
    end
    if seq==2
      shop = Shop.find(sid)
      xmpp2 = Xmpp.chat(to,uid,"你在#{shop.name}？")
      RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp2)
    end
  end
  
end