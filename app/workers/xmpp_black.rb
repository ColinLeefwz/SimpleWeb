class XmppBlack
  @queue = :xmpp

  def self.perform(uid,bid,block)
    RestClient.post("http://#{$xmpp_ip[1]}:5280/api/#{block}", 
      :uid => uid, :bid => bid)
  end
end