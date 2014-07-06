class CheckinUserMany
  include Mongoid::Document
  field :_id, type: String
  field :data, type: Hash #{uid => [[第一次的checkin_id1,第一次的checkin_id2,..],[第二次的checkin_id1]]}

end

