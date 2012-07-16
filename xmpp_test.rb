require 'rubygems'
require 'xmpp4r/client'
include Jabber


client = Client.new(JID::new("38@dface.cn"))
client.connect
client.auth("38")
client.send(Presence.new.set_type(:available))

msg = Message::new("1@dface.cn", "Hello, 世界!")
msg.type=:chat
client.send(msg)

#测试摇一摇
msg2 = Message::new("1@dface.cn")
h = REXML::Element::new("handshake")
h.add_namespace('http://dface.cn')
h.add_attribute("name","38 from ruby")
msg2.add_element(h)
msg2.type=:chat
client.send(msg2)


pres = Presence.new.set_type(:subscribe).set_to("s6@dface.cn")
client.send(pres)

client.add_presence_callback do |presence|
  puts presence
  if presence.from == "s6@dface.cn" && presence.ask == :subscribe
    client.send(presence.from, "I am so very happy you have accept my request John, you rock! I will spam you for the rest of my life, but I know you will understand because I feel we do 'connect'")
  end
end