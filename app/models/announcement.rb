class Announcement < ActiveRecord::Base
  include Storagable
  include ParamsConfig
  # announcement always belongs to an expert
  belongs_to :expert
  validates :expert, presence: true

  attached_file :attached_video_sd
  attached_file :attached_video_hd
  attached_file :cover
end
