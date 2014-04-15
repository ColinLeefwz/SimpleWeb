class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  field :subject_type, type: String
  field :subject_id, type: Integer
  field :name, type: String

  embedded_in :activity_stream
end

