# encoding: utf-8

class NewUserTalk
  @queue = :normal

  def self.perform(uid,sid,seq)
    user = User.find(uid)
    if user.gender==2
      to = "50bc20fcc90d8ba33600004b" #浦靠谱
    else
      to = "50bec2c1c90d8bd12f000086" #amanda林
      #to = User.fake_user(User.find_by_id(uid)).id
    end
    if seq==1
      Xmpp.send_chat(to, uid, "hi")
    end
    if seq==2
      Xmpp.send_chat(to, uid, "你在#{shop.name}？")
      chat2(uid) if user.gender==2
    end
  end
  
  def self.chat2(uid)
    to = "51427b92c90d8b670c00027b" #简单点
    hour = Time.now.hour
    if hour<12
      msg = "早上好🌻🙏"
    elsif hour<=13
      msg = "中午好☀🙏"
    elsif hour<=18
      msg = "下午好🌷"
    else
      msg = "晚上好🌙💤"
    end
    Resque.enqueue_in(15.seconds,XmppMsg, to ,uid, msg)
  end
  
end
