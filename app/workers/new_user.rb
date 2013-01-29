# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid,sid,od)
    ["502e6303421aa918ba000001","50446058421aa92042000002"].each do |to|
      NewUser.notify(uid,sid, to, od)
    end
    Resque.enqueue_in(2.seconds, NewUserWelcome, uid,sid,1)
    Resque.enqueue_in(6.seconds, NewUserWelcome, uid,sid,2)
    Resque.enqueue_in(9.seconds, NewUserWelcome, uid,sid,3)
    Resque.enqueue_in(15.seconds, NewUserTalk, uid,sid,1)
    Resque.enqueue_in(20.seconds, NewUserTalk, uid,sid,2)
    
  end
  
  def self.notify(uid,sid, to, od, gender=0)
    user = User.find(uid)
    if gender!=0
      return if user.gender!=gender
    end
    shop = Shop.find(sid)
    xmpp = Xmpp.chat(uid,to,"新用户:#{user.show_gender} #{shop.city_fullname} 排名#{od}:#{shop.name}")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
end