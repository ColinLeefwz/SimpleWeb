class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  field :subject_name, type: String
  field :subject_id, type: Integer
  field :object_type, type: String
  field :object_id, type: Integer
  field :action, type: String

  embedded_in :activity_stream
end

