class Announcement < ActiveRecord::Base
  include Storagable
  include ParamsConfig

  belongs_to :expert
  validates :expert, presence: true

  attached_file :attached_video_sd
  attached_file :attached_video_hd
  attached_file :cover

  def has_video?
    self.attached_video_sd_file_name.present? || self.attached_video_hd_file_name.present?
  end
end
