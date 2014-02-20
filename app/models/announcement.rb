class Announcement < ActiveRecord::Base
  include ParamsConfig

  belongs_to :expert
  validates :expert, presence: true

  has_attached_file :cover

  def has_video_to_present?
    self.attached_video_sd_file_name.present? || self.attached_video_hd_file_name.present?
  end

end
