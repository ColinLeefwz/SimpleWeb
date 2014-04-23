class ActivityStream
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: Integer
  field :last_read_time, type: DateTime
  embeds_many :activities

  validates :user_id, presence: true

end

