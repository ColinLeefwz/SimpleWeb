ActiveAdmin.register StaticPages do

  form do |f|
    f.inputs "Title" do
      f.input :title
      f.input :content
      f.input :image, as: :file
      f.actions
    end
  end

  controller do 
    def permitted_params
      params.permit static_pages: [:title, :content, :image]
    end
  end
end

