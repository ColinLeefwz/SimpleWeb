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

  controller do
    def permitted_params
      params.permit :id, video_interview: [:id, :title, :language, :cover, :description, :expert_id, {categories:[]}, Video::Attributes ]
    end
  end
end
