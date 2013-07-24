class XmppBlack
  @queue = :xmpp

  def self.perform(uid,bid,block)
    Xmpp.post("api/#{block}", :uid => uid, :bid => bid)
  end
end