# coding: utf-8

class Xmpp

  def self.chat(from,to,msg, id=nil, attrs="")
    msg2 = CGI.escapeHTML(msg)
    mid = id.nil?? $uuid.generate : id
    attrs += " NOLOG='1' " if (from.to_s == $gfuid || from.to_s == 'scoupon' || from.to_s == 'sphoto' || msg[0]==':') && attrs.index("NOLOG").nil?
    "<message id='#{mid}' to='#{to}@dface.cn' from='#{from}@dface.cn' type='chat' #{attrs}><body>#{msg2}</body></message>"
  end
  
  #发送个人聊天消息
  def self.send_chat(from,to,msg,id=nil, attrs="")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", Xmpp.chat(from,to,msg,id,attrs)) 
  end
  
  def self.gchat(from,to,msg, id=nil, attrs="")
    msg2 = CGI.escapeHTML(msg)
    mid = id.nil?? $uuid.generate : id
    "<message id='#{mid}' to='#{to}@dface.cn' from='#{from.to_i}@c.dface.cn' type='groupchat' #{attrs}><body>#{msg2}</body></message>"
  end 
  
  #在聊天室发送系统消息
  def self.send_gchat(from,to,msg, id=nil, attrs="")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", Xmpp.gchat(from,to,msg,id,attrs)) 
  end

  def self.gchat2(from,room,to,msg, id=nil, attrs="")
    msg2 = CGI.escapeHTML(msg)
    mid = id.nil?? $uuid.generate : id
    "<message id='#{mid}' to='#{to}@dface.cn' from='#{room.to_i}@c.dface.cn/#{from}' type='groupchat' #{attrs}><body>#{msg2}</body></message>"
  end 
  
  #在聊天室以特定用户身份发消息
  def self.send_gchat2(from,room,to,msg, id=nil, attrs="")
    return "消息：#{msg}" if ENV["RAILS_ENV"] != "production"
    RestClient.post("http://#{$xmpp_ip}:5280/rest", Xmpp.gchat2(from,room,to,msg,id,attrs))   
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
