ActiveAdmin.register Announcement do
  form partial: "form"

  index do
    column :title
    column :categories
    column :always_show
    column :attached_video_hd_file_name
    column :attached_video_sd_file_name
    column :created_at
    column :updated_at

    default_actions
  end

  controller do
    def permitted_params
      params.permit :id, announcement: [:id, :title, :language, :cover, :description, :always_show, :expert_id, {categories:[]}, 
                                        video_attributes: [:id, :cover, :SD_file_name, :SD_content_type, :SD_file_size, :SD_temp_path,  :HD_file_name, :HD_content_type, :HD_file_size, :HD_temp_path]]
    end
  end

end
