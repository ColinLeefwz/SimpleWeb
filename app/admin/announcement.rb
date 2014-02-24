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
      params.permit :id, announcement: [:id, :title, :language, :cover, :description, :always_show, :expert_id, {categories:[]}, Video::Attributes ]
    end
  end

end
