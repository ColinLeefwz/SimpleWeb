class RoomPhoto
  @queue = :photo

  def self.perform(roomid,imgid,txt,uid)
  	txt="" if txt.nil?
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => roomid , :message => "[img:#{imgid}]#{txt}",
        :uid => uid)  {|response, request, result| puts response }
  end
end