require 'rubygems'
require 'xmpp4r/client'
include Jabber
require 'eventmachine'

class Worker
  include EM::Deferrable

  def heavy_lifting
    30.times do |i|
      puts "Lifted #{i}"
      sleep 0.1
    end
    set_deferred_status :succeeded
  end
end

client = Client.new(JID::new("s1@dface.cn"))
client.connect
client.auth("pass")
client.send(Presence.new.set_type(:available))

def deliver(conn,who,msg)
  msg = Message::new(who, msg)
  msg.type=:chat
  conn.send(msg)
end




at_exit{ client.close() }

EM.run do
  client.add_message_callback do |message|
    case message.body
    when "exit" then
      EM.stop
    when "lift" then
      EM.spawn do
        worker = Worker.new
        worker.callback {deliver(client,message.from, "Done lifting")}
        worker.heavy_lifting
      end.notify
      deliver(client,message.from, "Scheduled heavy job...")
    else deliver(client,message.from, "Dunno how to #{message.body}")
    end
  end
end

