class CheckinUserMany
  include Mongoid::Document
  field :_id, type: String
  field :data, type: Hash

end

