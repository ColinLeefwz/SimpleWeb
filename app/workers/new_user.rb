# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid,sid)
    user = User.find(uid)
    shop = Shop.find(sid)
    xmpp = Xmpp.chat(uid,"502e6303421aa918ba000001","新用户来了:#{user.show_gender} #{shop.city_fullname} #{shop.name}")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
end