require 'rubygems'
require 'xmpp4r/client'
require 'xmpp4r/muc'
include Jabber

#Jabber::debug = true

client = Client.new(JID::new("s1@dface.cn"))
client.connect
client.auth("pass")
client.send(Presence.new.set_type(:available))

msg = Message::new("s2@dface.cn", 'hello')
msg.type=:chat
client.send(msg)


my_muc = Jabber::MUC::SimpleMUCClient.new(client)
my_muc.join(Jabber::JID.new('77524@c.dface.cn/38'))
my_muc.say("hello from ruby")


muc = Jabber::MUC::MUCClient.new(client)
muc.join(Jabber::JID.new('77524@c.dface.cn/38'))
muc.add_message_callback do |m|
     puts "[NEW MESSAGE]" + m.to_s
end


#测试摇一摇
msg2 = Message::new("77524@c.dface.cn")
h = REXML::Element::new("handshake")
h.add_namespace('http://dface.cn')
h.add_attribute("name","38 from ruby")
msg2.add_element(h)
msg2.type=:groupchat
muc.send(msg2)



pres = Presence.new.set_type(:subscribe).set_to("s6@dface.cn")
client.send(pres)

client.add_presence_callback do |presence|
  puts presence
  if presence.from == "s6@dface.cn" && presence.ask == :subscribe
    client.send(presence.from, "I am so very happy you have accept my request John, you rock! I will spam you for the rest of my life, but I know you will understand because I feel we do 'connect'")
  end
end