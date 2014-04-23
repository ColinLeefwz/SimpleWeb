class ActivityStream
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: Integer
  field :last_read_time, type: DateTime
  embeds_many :activities, order: :created_at.desc

  validates :user_id, presence: true

  def self.find(input)
    begin
      find_by(user_id: input)
    rescue
      super
    end
  end
end

