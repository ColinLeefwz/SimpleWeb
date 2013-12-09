ActiveAdmin.register VideoInterview do
	# form partial: "form"
	form do |f|
		f.inputs "Basic" do
			f.input :title
			f.input :description
			f.input :expert
			f.input :categories, as: :check_boxes, collection: Category.all
		end

		f.inputs "Video" do

		end
	end

  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
