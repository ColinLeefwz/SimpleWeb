class RoomMsgDel
  include Mongoid::Document
  field :mid
  field :time, type:Integer
  field :uid
  field :text

end
