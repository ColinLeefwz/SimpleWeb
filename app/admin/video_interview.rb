ActiveAdmin.register VideoInterview do
  form partial: "form"

  index do
    column :title
    column :categories
    column :description
    column :attached_video_hd_file_name
    column :attached_video_sd_file_name
    column :created_at
    column :updated_at

    default_actions
  end

  permit_params :title, :language, :cover, :description, :expert_id, {categories:[]}, :attached_video_hd_file_name, :attached_video_hd_content_type, :attached_video_hd_file_size, :hd_url, :attached_video_sd_file_name, :attached_video_sd_content_type, :attached_video_sd_file_size, :sd_url, :id

end
