class Announcement < ActiveRecord::Base
  include ParamsConfig

  belongs_to :expert
  validates :expert, presence: true

  has_one :video, as: :videoable
  accepts_nested_attributes_for :video, allow_destroy: true

  has_attached_file :cover

  def has_video_to_present?
    self.video.try(:SD_file_name) || self.video.try(:HD_file_name)
  end
end
