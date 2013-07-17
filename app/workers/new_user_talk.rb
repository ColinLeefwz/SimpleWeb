# encoding: utf-8

class NewUserTalk
  @queue = :normal

  def self.perform(uid,sid,seq)
    user = User.find(uid)

    hour = Time.now.hour
    week = Time.now.wday
    if ((1..5).include?week) && hour > 8 && hour < 19
      if user.gender == 2
        to = ["51418836c90d8bc37b000567" #'怪咖叔叔', 马甲，  运营-孙世杰
             ]
      else
        to = ["513ed1e7c90d8b590100016f",  #球球爱嘟嘴, 马甲，运营-董玉华
              "50bec2c1c90d8bd12f000086"   #amanda林
             ]
      end
    
    elsif ((1..5).include?week) && hour < 24 && hour > 19
      if user.gender == 2
        to = ["51418836c90d8bc37b000567" #'怪咖叔叔', 马甲，  运营-孙世杰
             ]
      else
        to = ["513ed1e7c90d8b590100016f",  #球球爱嘟嘴, 马甲，运营-董玉华
              "50bec2c1c90d8bd12f000086"   #amanda林
             ]
      end

    else ((6..7).include?week) && hour > 9 && hour < 24
      if user.gender == 2
        to = ["51427b92c90d8b670c00027b" #Jap UU  马甲
             ]
      else
        to = ["514190f8c90d8bc67b00054a" #可儿
             ]
      end
    end

    to = to[user.id.generation_time.sec%to.size]

    if seq == 1 && (to != "51418836c90d8bc37b000567")
      Xmpp.send_chat(to, uid, "hi")
    end
    if seq == 2 && (to == "51418836c90d8bc37b000567")
      shop = Shop.find_by_id(sid)
      Xmpp.send_chat(to, uid, "你在#{shop.name}？")
    end
  end

end
