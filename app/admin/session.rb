ActiveAdmin.register Session do

  index do
    column :cover do |session|
      link_to image_tag(session.cover.url, width: "50"), admin_session_path(session)
    end
    column :title do |session|
      link_to(session.title, admin_session_path(session))
    end
    column "Expert", :expert_id do |session|
      link_to session.expert.name, admin_expert_path(session.expert_id)
    end
    column :always_show do |session|
      session.always_show.to_s
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


  form html: {enctype: "multipart/form-data"} do |f|
    f.inputs "Session", multipart: true do
      f.input :title
      f.input :expert
      f.input :always_show
      f.input :cover, as: :file # , hint: f.template.image_tag(f.object.cover.url)
      f.input :status
      f.input :content_type, as: :select, collection: Session::CONTENT_TYPE
      f.input :description, :input_html => { :class => 'ckeditor' }
      f.input :category, as: :select, collection: Session::CATEGORY
      f.input :video
      f.input :location
      f.input :price
      f.actions
    end
  end


  show do |session|
    attributes_table do
      row :title
      row :expert do
        link_to session.expert.name, admin_expert_path(session.expert_id)
      end
      row :always_show do
        session.always_show.to_s
      end
      row :cover do
        image_tag session.cover.url, width: "70"
      end
      row :status
      row :content_type
      row :description do
        session.description.html_safe
      end
      row :category
      row :video do
        link_to "source", session.video.url
      end
      row :location
      row :price
    end
  end

  controller do
    def permitted_params
      params.permit session: [:title, :expert_id, :always_show, :created_date, :description, :cover, :status, :content_type, :category, :location, :price, :video]
    end
  end

end
