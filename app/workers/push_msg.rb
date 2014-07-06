# encoding: utf-8

class PushMsg
  @queue = :normal

  def self.perform(token, name, msg, uid, type="push")
    return if token.nil?
    Rails.cache.fetch("P_MSG#{token}#{msg[-10,-1]}", :expires_in => 10.minutes) do
      Rails.cache.fetch("P_MSG#{token}#{msg[-20,-1]}", :expires_in => 6.hours) do
        msg = msg[0,18] + "..." if msg.bytesize>80
        Xmpp.post("api/push", :token => token+name, :uid => uid, :txt => msg)
        "1"
      end
    end
  end
  
end