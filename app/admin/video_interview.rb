ActiveAdmin.register VideoInterview do
  form partial: "form"

  index do
    column :cover do |video_interview|
      link_to image_tag(video_interview.cover.url, width: "50"), admin_video_interview_path(video_interview)
    end

    column :title

    column :categories do |video_interview|
      video_interview.category_names
    end

    column :updated_at

    default_actions
  end

  controller do
    def permitted_params
      params.permit :id, video_interview: [:id, :title, :language, :cover, :description, :expert_id, {category_ids:[]}, Video::Attributes ]
    end
  end
end
