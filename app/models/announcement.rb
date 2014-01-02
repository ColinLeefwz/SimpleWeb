class Announcement < ActiveRecord::Base
	include Storagable

	attached_file :attached_video_sd
	attached_file :attached_video_hd
	attached_file :cover
  # announcement always belongs to an expert
  belongs_to :expert
  validates :expert, presence: true

end
