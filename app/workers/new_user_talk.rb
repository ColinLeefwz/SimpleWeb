# encoding: utf-8

class NewUserTalk
  @queue = :normal

  def self.perform(uid,sid,seq)
    user = User.find(uid)

    hour = Time.now.hour
    week = Time.now.wday
    date = Time.now.strftime("%Y-%m-%d")

    to2 = ["50bc20fcc90d8ba33600004b" #“浦靠谱” 运营总监浦希哲
          ]

    if ((0..6).include?week) && hour > 8 && hour < 24
      if user.gender == 2
        to = ["51418836c90d8bc37b000567"
             ]
      else
        to = ["50bec2c1c90d8bd12f000086"
             ]
      end
    end

    to = to[user.id.generation_time.sec%1]

    $redis.sadd("PL#{date}#{to}",user.id)

    if seq == 1 && (to != "51418836c90d8bc37b000567")
      Xmpp.send_chat(to, uid, "hi")
    end
    if seq == 1 && user.gender == 2
      Xmpp.send_chat(to2[0], uid, "hi")
    end
    if seq == 2 && (to == "51418836c90d8bc37b000567")
      shop = Shop.find_by_id(sid)
      Xmpp.send_chat(to, uid, "hi,你也在#{shop.name}？")
    end
  end

end