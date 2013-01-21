# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid,sid)
    ["502e6303421aa918ba000001","50446058421aa92042000002","50bc20fcc90d8ba33600004b","502e6303421aa918ba000079"].each do |to|
      NewUser.notify(uid,sid, to)
    end
  end
  
  def self.notify(uid,sid, to)
    user = User.find(uid)
    shop = Shop.find(sid)
    return if user.wb_v
    return unless shop.city=="0571"
    xmpp = Xmpp.chat(uid,to,"新用户来了:#{user.show_gender} #{shop.city_fullname} #{shop.name}")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
end