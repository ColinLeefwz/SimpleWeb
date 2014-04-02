ActiveAdmin.register Announcement do
  form partial: "form"

  index do
    column :title
    column :categories do |announcement|
      announcement.category_names
    end
    column :always_show
    column :created_at
    column :updated_at

    default_actions
  end

  controller do
    def permitted_params
      params.permit :id, announcement: [:id, :title, :language, :cover, :description, :always_show, :expert_id, {category_ids:[]}, Video::Attributes ]
    end
  end

end
