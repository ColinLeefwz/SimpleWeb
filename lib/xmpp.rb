class Xmpp

  def self.chat(from,to,msg)
    msg2 = CGI.escapeHTML(msg)
    "<message id='#{$uuid.generate}' to='#{to}@dface.cn' from='#{from}@dface.cn' type='chat'><body>#{msg2}</body></message>"
  end
  
  def self.gchat(from,to,msg)
    msg2 = CGI.escapeHTML(msg)
    "<message id='#{$uuid.generate}' to='#{to}@dface.cn' from='#{from}@c.dface.cn' type='groupchat'><body>#{msg2}</body></message>"
  end 


end
