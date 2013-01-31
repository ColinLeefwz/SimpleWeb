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
1、一个月内摇进10个现场以上
2、分享10张现场图片到新浪微博
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

def msg3(client,from)
  str = <<-EOF   
试试：
回复2、遇见一位同城异性
回复3、遇见一位国内异性
回复4、遇见一位国外异性
  EOF
  msg = Message::new(from, str)
  msg.type=:chat
  client.send(msg)  
end

def help_msg(client,from)
  str = <<-EOF   
脸脸帮助：回复
1、如何成为脸脸种子用户?
2、遇见一位同城异性
3、遇见一位国内异性
4、遇见一位国外异性
5、遇见一位同城同性
6、遇见一位国内同性
7、遇见一位国外同性
试试吧！
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

def want_msg(client,from,to)
  gstr = to.gender==2? "美女" : "帅哥"
  msg = Message::new(from, "脸脸找到了一位#{gstr}: #{to.name}, #{City.city_name(to.city)}. 返回到'对话'中查看吧。")
  msg.type=:chat
  client.send(msg)
end

$count=1
def find_user(user,int)
  $count+=1
  skip = $count % 10
  case int
  when 2
    ck = User.where({city:user.city, gender:{"$ne" => user.gender}, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
  when 3
    ck = User.where({city:{"$ne" => user.city}, gender:{"$ne" => user.gender}, auto:nil,invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
  when 4
    ck = User.where({city:nil, gender:{"$ne" => user.gender}, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
  when 5
    ck = User.where({city:user.city, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
  when 6
    ck = User.where({city:{"$ne" => user.city}, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
  when 7
    ck = User.where({city:nil, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
  end
  return nil if (ck.nil? || ck.id.to_s==$gfuid || ck.id.to_s=="5032ef4e421aa91a1e00001f") #点世界id
  ck
end

def want(client,message,int)
  user = User.find_by_id(message.from.to_s[0,24])
  if user.nil?
    error_msg(client,message.from)
  else
    to = find_user(user,int)
    if to.nil?
      error_msg(client,message.from)
      return
    end
    want_msg(client,message.from,to)
    xmpp = Xmpp.chat(to.id,user.id,": (此为系统消息，不是#{to.name}所发)")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
end

#http://api.simsimi.com/request.p?key=68ebadb4-16f3-4fc2-98bf-673a43f161e0&ft=1.0&text=test&lc=ch

def chat_process(client,m)
  txt = m.body.gsub(/\W/, "")
  int = txt.to_i
  if int==1
    msg1(client,m.from)
    sleep(5)
    msg2(client,m.from)
  elsif  txt=="0" || txt=="o"
    msg3(client,m.from)
  elsif  (int>1 && int<8)
    want(client,m,int)
  else
    help_msg(client,m.from)
  end
end

$message=nil

client.add_message_callback do |m|
  $message=m
  begin
    if m.type.to_s=="chat"
      Rails.logger.debug m
      puts "#{m.from.to_s[0,24]},#{m.body},#{Time.now.to_s}"
      chat_process(client,m)
    end
  rescue Exception => e
    puts e
    puts e.backtrace
  end
end

sleep(100000)
