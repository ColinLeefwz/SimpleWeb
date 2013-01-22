# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid,sid)
    ["502e6303421aa918ba000001","50446058421aa92042000002","50bc20fcc90d8ba33600004b","502e6303421aa918ba000079"].each do |to|
      NewUser.notify(uid,sid, to)
    end
    ["50fe2e9bc90d8b6c3a0001fd","50fe294cc90d8b143a000136","50bec2c1c90d8bd12f000086"].each do |to|
      NewUser.notify(uid,sid, to, 1)
    end
  end
  
  def self.notify(uid,sid, to, gender=0)
    user = User.find(uid)
    if gender!=0
      return if user.gender!=gender
    end
    shop = Shop.find(sid)
    xmpp = Xmpp.chat(uid,to,"新用户来了:#{user.show_gender} #{shop.city_fullname} #{shop.name}")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
end