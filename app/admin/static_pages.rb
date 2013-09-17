ActiveAdmin.register StaticPages do

  form do |f|
    f.inputs "Title" do
      f.input :title
      f.input :content
      f.input :image, as: :file
    end
  end

end
