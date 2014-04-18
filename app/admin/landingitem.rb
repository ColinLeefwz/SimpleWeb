ActiveAdmin.register Landingitem do

  config.sort_order = "num_asc"

  index do
    column :id
    column :num

    column :resource_type do |item|
      item.landingable_type
    end

    column :resource_title do |item|
      item.fetch_object.title
    end

    column :cover do |item|
      image_tag(item.fetch_object.cover.url, width: "50")
    end

    column :expert do |item|
      object = item.fetch_object
      if object.is_a? Course
        object.experts.map &:name
      else
        object.expert.name
      end
    end
    
    column :updated_at
    column :created_at

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :landingable_type, input_html: { readonly: true }
      f.input :landingable_id, input_html: { readonly: true }
      f.input :num, as: :select, collection: 1..Landingitem.all.count
      f.actions
    end
  end

  controller do
    def permitted_params
      params.permit :id, landingitem: [:landingable_type, :landingable_id, :num]
    end
  end
  
end
