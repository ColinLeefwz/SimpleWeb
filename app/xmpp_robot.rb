# coding: utf-8

require 'rubygems'
require 'xmpp4r/client'
include Jabber

=begin
EXCEPTION:
    REXML::ParseException
    #<Encoding::CompatibilityError: incompatible encoding regexp match (UTF-8 regexp with ASCII-8BIT string)>
    /Users/ylt/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/rexml/source.rb:210:in `match'
    /Users/ylt/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/rexml/source.rb:210:in `match'
    /Users/ylt/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/rexml/parsers/baseparser.rb:419:in `pull_event'
    /Users/ylt/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/rexml/parsers/baseparser.rb:183:in `pull'
    /Users/ylt/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/rexml/parsers/sax2parser.rb:92:in `parse'
    /Users/ylt/.rvm/gems/ruby-1.9.3-p327/gems/xmpp4r-0.5/lib/xmpp4r/streamparser.rb:79:in `parse'
    /Users/ylt/.rvm/gems/ruby-1.9.3-p327/gems/xmpp4r-0.5/lib/xmpp4r/stream.rb:75:in `block in start'
    ...
    Exception parsing
    Line: 
    Position: 0
    Last 80 unconsumed characters:
    啊</body>
    /Users/ylt/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/rexml/parsers/baseparser.rb:435:in `rescue in pull_event'

=end

# Encoding patch
require 'socket'
class TCPSocket
    def external_encoding
        Encoding::BINARY
    end
end

require 'rexml/source'
class REXML::IOSource
    alias_method :encoding_assign, :encoding=
    def encoding=(value)
        encoding_assign(value) if value
    end
end

begin
    # OpenSSL is optional and can be missing
    require 'openssl'
    class OpenSSL::SSL::SSLSocket
        def external_encoding
            Encoding::BINARY
        end
    end
rescue
end
# End Encoding patch


#Jabber::debug = true

client = Client.new(JID::new("#{$gfuid}@dface.cn"))
client.connect($xmpp_ip)
client.auth("4f84a6d71c6ac96c")
client.send(Presence.new.set_type(:available))

def msg1(client,from)
  str = <<-EOF   
成为脸脸种子用户要求：
1、连续5天摇进10个现场以上
2、分享5张现场图片到新浪微博
3、邀请好友三个以上
  EOF
  msg = Message::new(from, str)
  msg.type=:chat
  client.send(msg)  
end

def msg2(client,from)
  str = <<-EOF   
你将获得：
1、脸脸种子勋章一枚，彰显大姐大/大哥大身份
2、优先享受脸脸最新优惠活动
赶快行动吧！
  EOF
  msg = Message::new(from, str)
  msg.type=:chat
  client.send(msg)  
end

def error_msg(client,from)
  msg = Message::new(from, "抱歉，出错了！")
  msg.type=:chat
  client.send(msg)  
end

def want_msg(client,from,ck)
  gstr = ck.user.gender==2? "美女" : "帅哥"
  msg = Message::new(from, "脸脸找到了一位#{gstr}: #{ck.user.name}, #{ck.shop.city_name}.")
  msg.type=:chat
  client.send(msg)
end

def want(client,message)
  user = User.find_by_id(message.from.to_s[0,24])
  if user.nil?
    error_msg(client,message.from)
  else
    ck = Checkin.where({sex:{"$ne" => user.gender}}).last
    Rails.logger.debug("#{user},#{ck}")
    want_msg(client,message.from,ck)
    xmpp = Xmpp.chat(ck.user.id,user.id,": hi. (此为系统消息，不是#{ck.user.name}所发)")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
end

def chat_process(client,m)
  txt = m.body.gsub(/\W/, "")
  if txt=="1"
    msg1(client,m.from)
    sleep(5)
    msg2(client,m.from)
  elsif  txt=="2" || txt=="我要" || txt=="找人"
    want(client,m)
  end
end

$message=nil

client.add_message_callback do |m|
  $message=m
  begin
    if m.type.to_s=="chat"
      Rails.logger.debug m
      chat_process(client,m)
    end
  rescue Exception => e
    puts e
  end
end

sleep(100000)