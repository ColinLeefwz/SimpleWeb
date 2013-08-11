# coding: utf-8

class Xmpp
  
  $xmpp_ip_seq=rand($xmpp_ips.size)
  
  def self.cur_xmpp_ip
    $xmpp_ips[$xmpp_ip_seq]
  end
  
  def self.next_xmpp_ip
    $xmpp_ip_seq += 1
    $xmpp_ip_seq = 0 if $xmpp_ip_seq >= $xmpp_ips.size
    $xmpp_ips[$xmpp_ip_seq]
  end
  
  def self.get(path, headers={}, &block)
    begin 
      RestClient.get("http://#{cur_xmpp_ip}:5280/#{path}", headers, &block)
    rescue Errno::ECONNREFUSED => e
      RestClient.get("http://#{next_xmpp_ip}:5280/#{path}", headers, &block)
    end
  end
  
  def self.post(path, payload, headers={}, &block)
    begin 
      RestClient.post("http://#{cur_xmpp_ip}:5280/#{path}", payload, headers, &block)
    rescue Errno::ECONNREFUSED => e
      RestClient.post("http://#{next_xmpp_ip}:5280/#{path}", payload, headers, &block)
    end
  end

  def self.chat(from,to,msg, id=nil, attrs="")
    msg2 = CGI.escapeHTML(msg)
    mid = id.nil?? $uuid.generate : id
    attrs += " NOLOG='1' " if (from.to_s == $gfuid || from.to_s == 'scoupon' || from.to_s == 'sphoto' || msg[0]==':') && attrs.index("NOLOG").nil?
    "<message id='#{mid}' to='#{to}@dface.cn' from='#{from}@dface.cn' type='chat' #{attrs}><body>#{msg2}</body></message>"
  end
  
  #发送个人聊天消息
  def self.send_chat(from,to,msg,id=nil, attrs="")
    post("rest", Xmpp.chat(from,to,msg,id,attrs)) 
  end
  
  def self.gchat(from,to,msg, id=nil, attrs="")
    msg2 = CGI.escapeHTML(msg)
    mid = id.nil?? $uuid.generate : id
    "<message id='#{mid}' to='#{to}@dface.cn' from='#{from.to_i}@c.dface.cn' type='groupchat' #{attrs}><body>#{msg2}</body></message>"
  end 
  
  #在聊天室发送系统消息
  def self.send_gchat(from,to,msg, id=nil, attrs="")
    post("rest", Xmpp.gchat(from,to,msg,id,attrs)) 
  end

  def self.gchat2(from,room,to,msg, id=nil, attrs="")
    msg2 = CGI.escapeHTML(msg)
    mid = id.nil?? $uuid.generate : id
    "<message id='#{mid}' to='#{to}@dface.cn' from='#{room.to_i}@c.dface.cn/#{from}' type='groupchat' #{attrs}><body>#{msg2}</body></message>"
  end 
  
  #在聊天室以特定用户身份发消息
  def self.send_gchat2(from,room,to,msg, id=nil, attrs="")
    return "消息：#{msg}" if ENV["RAILS_ENV"] != "production"
    post("rest", Xmpp.gchat2(from,room,to,msg,id,attrs))   
  end
  
  def self.error_notify(str, uid=$yuanid)
    Resque.enqueue(XmppMsg, $gfuid,uid,str)  if Rails.env=="production"
  end
  
  def self.test
    cur_ip = nil
    begin
      $xmpp_ips.each do |ip|
        cur_ip = ip
        RestClient.post("http://#{ip}:5280/api/room", 
          :roomid  => "4928288" , :message=> "测试一下" ,
          :uid => "502e6303421aa918ba000001") 
      end
    rescue Exception => e
      raise cur_ip
    end
  end

end
