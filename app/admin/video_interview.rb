ActiveAdmin.register VideoInterview do
	form partial: "form"

	# form do |f|
	# 	f.inputs "Basic" do
	# 		f.input :title
	# 		f.input :description
	# 		f.input :expert
	# 		f.input :categories, as: :check_boxes, collection: Category.all
	# 		f.actions
	# 	end
	# end

	# f.inputs "Video" do
	# 	s3_uploader_form id: "s3_video_interview", callback_url: admin_video_interviews_path do
	# 		file_field_tag :file, multiple: false
	# 	end


  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
