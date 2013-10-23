class RoomMsgDel
  include Mongoid::Document
  field :_id, type: String
  field :mid
  field :time, type:Integer
  field :uid
  field :text
  field :room, type:Integer


  def self.init_root_msg_del_redis
    self.all.each do |mdr|
      $redis.sadd("RoomMsgDel#{mdr.room.to_i}", mdr._id )
    end
  end

end
