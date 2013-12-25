class VideoInterview < ActiveRecord::Base
	include Storagable
	belongs_to :expert

	attached_file :attached_video_hd
	attached_file :attached_video_sd
	attached_file :cover
	
	def	content_type
		"VideoInterview"
	end

	def	always_show
		false
	end

end
