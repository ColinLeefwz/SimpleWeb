class ActivityStream
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: Integer
  embeds_many :activities

  validates :user_id, presence: true

end

