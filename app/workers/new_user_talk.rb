# encoding: utf-8

class NewUserTalk
  @queue = :normal

  def self.perform(uid,sid,seq)
    user = User.find(uid)
    if user.gender==2
      to = ["50bc20fcc90d8ba33600004b", #“浦靠谱” 运营总监浦希哲
        "51418836c90d8bc37b000567" #'怪咖叔叔', 马甲，  运营-孙世杰
      ]
    else
      to = ["50bec2c1c90d8bd12f000086", #amanda林
        "513ed1e7c90d8b590100016f"  #球球爱嘟嘴, 马甲，运营-董玉华
      ] #
      #to = User.fake_user(User.find_by_id(uid)).id
    end
    to = to[user.id.generation_time.sec%to.size]
    if seq==1
      Xmpp.send_chat(to, uid, "hi")
    end
    if seq==2
      shop = Shop.find_by_id(sid)
      Xmpp.send_chat(to, uid, "你在#{shop.name}？")
      chat2(uid) if user.gender==2
    end
  end
  
  def self.chat2(uid)
    to = "51427b92c90d8b670c00027b" #Jap UU  马甲
    hour = Time.now.hour
    if hour>20 && hour <=3
      msg = "晚上好🌙💤"
    elsif hour>3 && hour < 6
      msg = "凌晨好💤🙏"
    elsif hour<12
      msg = "早上好🌻🙏"
    elsif hour<=13
      msg = "中午好☀🙏"
    elsif hour<18
      msg = "下午好🌷"
    else
      msg = "晚上好🌙🙏"
    end
    Resque.enqueue_in(15.seconds,XmppMsg, to ,uid, msg)
  end
  
end
