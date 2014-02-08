ActiveAdmin.register Article do

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
    column :categories
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
      f.input :categories, as: :check_boxes, collection: Category.select(:name).map(&:name)
      f.input :video
      f.input :location
      f.input :price
      f.input :start_date
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
        description = session.description || "  "
        description.html_safe
      end
      row :categories
      row :video do
        link_to "source", session.video.url
      end
      row :location
      row :price
      row :start_date
    end
  end

  controller do
    def permitted_params
      params.permit session: [:title, :expert_id, :always_show, :created_date, :description, :cover, :status, :content_type, {categories:[]}, :location, :price, :video, :start_date]
    end
  end

end
