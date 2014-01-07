class VideoInterview < ActiveRecord::Base
  include Storagable
  include ParamsConfig

  # video interviews always belongs to an expert
  belongs_to :expert
  validates :expert, presence: true

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions


  attached_file :attached_video_hd
  attached_file :attached_video_sd
  attached_file :cover

	def to_param
		permalink
	end

	protected
	def permalink
		"#{id}-#{title.parameterize}"
	end
end
