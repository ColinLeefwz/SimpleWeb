class Xmpp

  def self.chat(from,to,msg)
    msg2 = CGI.escapeHTML(msg)
    "<message id='#{$uuid.generate}' to='#{to}@dface.cn' from='#{from}@dface.cn' type='chat'><body>#{msg2}</body></message>"
  end
  
  def self.send_chat(from,to,msg)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", Xmpp.chat(from,to,msg)) 
  end
  
  def self.gchat(from,to,msg)
    msg2 = CGI.escapeHTML(msg)
    "<message id='#{$uuid.generate}' to='#{to}@dface.cn' from='#{from}@c.dface.cn' type='groupchat'><body>#{msg2}</body></message>"
  end 
  
  def self.send_gchat(from,to,msg)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", Xmpp.gchat(from,to,msg)) 
  end

  def self.gchat2(from,room,to,msg)
    msg2 = CGI.escapeHTML(msg)
    "<message id='#{$uuid.generate}' to='#{to}@dface.cn' from='#{room}@c.dface.cn/#{from}' type='groupchat'><body>#{msg2}</body></message>"
  end 
  
  def self.send_gchat2(from,room,to,msg)
    RestClient.post("http://#{$xmpp_ip}:5280/rest", Xmpp.gchat2(from,room,to,msg))   
  end

end
