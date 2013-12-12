ActiveAdmin.register VideoInterview do
	form partial: "form"

	permit_params :title, :description, :expert_id, {categories:[]}, :attached_video_hd_file_name, :attached_video_hd_content_type, :attached_video_hd_file_size, :hd_url, :attached_video_sd_file_name, :attached_video_sd_content_type, :attached_video_sd_file_size, :sd_url
  
end
