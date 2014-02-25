ActiveAdmin.register StaticPages do

  index do
    column :title do |s|
     link_to s.title, admin_static_page_path(s)
    end
    column :created_at
    column :image_file_name
  end

  form do |f|
    f.inputs "static pages" do
      f.input :title
      f.input :content, :input_html => {:class => 'ckeditor'}
      #f.input :image, as: :file
      f.actions
    end
  end

  show do |s|
    attributes_table do
      row :title
      row :content do
        s.content.html_safe
      end
    end
  end
        
  controller do 
    def permitted_params
      params.permit :id, static_pages: [:id, :title, :content, :image]
    end
  end
end

