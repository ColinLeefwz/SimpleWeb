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

client.add_message_callback do |m|
  if m.type.to_s=="chat"
    puts m
    if m.body=="1"
      msg1(client,m.from)
      sleep(5)
      msg2(client,m.from)
    end
  end
end

sleep(100000)