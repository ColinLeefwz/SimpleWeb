class RoomPhoto
  @queue = :photo

  def self.perform(roomid,imgid,txt,uid)
    RestClient.post("http://#{$xmpp_ip}:5280/api/img", 
        :roomid  => roomid , :imgid => imgid, :txt => txt ,
        :uid => uid)  {|response, request, result| puts response }
  end
end