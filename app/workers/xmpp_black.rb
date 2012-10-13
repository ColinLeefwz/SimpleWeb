class XmppBlack
  @queue = :xmpp

  def self.perform(uid,bid,block)
    RestClient.post("http://#{$xmpp_ip}:5280/api/#{block}", 
      :uid => uid, :bid => bid)  {|response, request, result| puts response }
  end
end