class VideoInterview < ActiveRecord::Base
  include ParamsConfig

  has_one :video, as: :videoable, dependent: :destroy
  accepts_nested_attributes_for :video, allow_destroy: true

  belongs_to :expert
  validates :expert, presence: true

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  has_one :visit, as: :visitable

  has_attached_file :cover

  def editable
    true
  end

  def has_video_to_present?
    self.video.SD_file_name|| self.video.HD_file_name
  end
end
