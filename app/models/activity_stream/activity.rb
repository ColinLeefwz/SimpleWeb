class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  field :subject_type, type: String
  field :subject_id, type: Integer
  field :object_type, type: String
  field :object_id, type: Integer
  field :action, type: String

  embedded_in :activity_stream

  def subject
    subject_type.constantize.find(subject_id)
  end

  def object
    object_type.constantize.find(object_id)
  end
end

