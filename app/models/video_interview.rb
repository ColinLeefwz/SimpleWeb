class VideoInterview < ActiveRecord::Base
  include ParamsConfig

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
    self.attached_video_hd_file_name.present? || self.attached_video_sd_file_name.present?
  end
end
