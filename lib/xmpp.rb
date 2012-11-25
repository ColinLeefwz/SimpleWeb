class Xmpp

  def self.chat(from,to,msg)
    "<message id='#{$uuid.generate}' to='#{to}@dface.cn' from='#{from}@dface.cn' type='chat'><body>#{msg}</body></message>"
  end
  
  def self.gchat(from,to,msg)
    "<message id='#{$uuid.generate}' to='#{to}@dface.cn' from='#{from}@c.dface.cn' type='groupchat'><body>#{msg}</body></message>"
  end 


end
