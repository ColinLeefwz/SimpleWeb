ActiveAdmin.register Session do

  index do
    column :cover do |session|
      image_tag(session.cover.url, size: "50x50")
    end
    column :title do |session|
      link_to(session.title, admin_session_path(session))
    end
    column "Expert", :expert_id do |session|
      link_to(session.expert.name, admin_expert_path(session.expert_id))
    end
    column :status
    column :content_type
    column :category
    column :location
    column :price, sortable: :price do |session|
      number_to_currency(session.price, unit: "USD: ")
    end
    default_actions
  end


  form do |f|
    f.inputs do
      f.input :title
      f.input :expert
      f.input :cover
      f.input :status
      f.input :content_type
      f.input :description
      f.input :category
      f.input :video
      f.input :location
      f.input :price
      f.actions
    end
  end

  controller do
    def permitted_params
      params.permit session: [:title, :expert_id, :created_date, :description]
    end
  end

end
