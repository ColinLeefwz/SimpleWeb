# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid,sid,od)
    ["502e6303421aa918ba000001","50446058421aa92042000002","50ffd0e5c90d8bf7480000b7"].each do |to|
      NewUser.notify(uid,sid, to, od)
    end
    ["502e6303421aa918ba000079"].each do |to|
      NewUser.notify(uid,sid, to, od, 2 )
    end
    Resque.enqueue(NewUserWelcome, uid,sid,1)
    Resque.enqueue_in(3.seconds, NewUserWelcome, uid,sid,2)
    Resque.enqueue_in(6.seconds, NewUserWelcome, uid,sid,3)
    Resque.enqueue_in(20.seconds, NewUserWelcome, uid,sid,4)
    if User.find(uid).gender
      Resque.enqueue_in(50.seconds, NewUserTalk, uid,sid,1)
      Resque.enqueue_in(55.seconds, NewUserTalk, uid,sid,2)
    end
  end
  
  def self.notify(uid,sid, to, od, gender=0)
    user = User.find(uid)
    if gender!=0
      return if user.gender!=gender
    end
    shop = Shop.find(sid)
    if user.qq
      from="qq"
    else
      from="微博"
    end
    xmpp = Xmpp.chat(uid,to,"#{user.show_gender}:#{od}:#{from} #{shop.name} #{shop.city_fullname}")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
end
