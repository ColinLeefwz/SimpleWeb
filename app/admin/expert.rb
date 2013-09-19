ActiveAdmin.register Expert do

	index do
		column :name do |expert|
			link_to(expert.name, admin_expert_path(expert))
		end
		# column "Avatar", :image_url do |expert|
		#   link_to image_tag(expert.avatar.url, width: "50"), admin_expert_path(expert)
		# end
		column :title do |e|
			e.profile.title
		end

		column :company do |e|
			e.profile.company
		end

		column :location do |e|
			e.profile.location
		end

		column :email
		default_actions
	end


	form do |f|
		f.inputs do
			f.input :first_name
			f.input :last_name
			# f.input :avatar, as: :file
			f.input :email
			f.input :password, as: :password if f.object.new_record?

			f.inputs name: "Profiles", for: [:profile, f.object.profile || ExpertProfile.new] do |profile_form|
				profile_form.input :title
				profile_form.input :company
				profile_form.input :location
				profile_form.input :expertise
				profile_form.input :web_site
				profile_form.input :testimonials
				profile_form.input :additional
			end
			f.actions
		end
	end


	show do |expert|
		attributes_table do
			row :name
			# row :avatar do
			#   image_tag expert.avatar.url, width: "70"
			# end
			row :email
			row :title do |expert|
				expert.profile.title
			end

			row :company do |expert|
				expert.profile.company
			end

			row :location do |expert|
				expert.profile.location
			end

			row :expertise do |expert|
				expert.profile.location
			end

			row :web_site do |expert|
				expert.profile.location
			end

			row :testimonials do |expert|
				expert.profile.location
			end

			row :additional do |expert|
				expert.profile.location
			end
		end
	end


	controller do
		def update
			@expert = Expert.find params[:id]
			expert_attributes = params[:expert]
			@expert.update_attributes! first_name: expert_attributes[:first_name], last_name: expert_attributes[:last_name], email: expert_attributes[:email]

			@profile = ExpertProfile.find params[:expert][:profile_attributes][:id]

			profile_attributes = params[:expert][:profile_attributes]
			@profile.update_attributes title: profile_attributes[:title], company: profile_attributes[:company], location: profile_attributes[:location], expertise: profile_attributes[:expertise], web_site: profile_attributes[:web_site], testimonials: profile_attributes[:testimonials], additional: profile_attributes[:additional]

			redirect_to admin_expert_path @expert
		end

		def create
			expert_attributes = params[:expert]
			@expert = Expert.create(first_name: expert_attributes[:first_name], last_name: expert_attributes[:last_name], email: expert_attributes[:email], password: expert_attributes[:password])

			profile_attributes = params[:expert][:profile_attributes]
			@profile = @expert.build_profile title: profile_attributes[:title], company: profile_attributes[:company], location: profile_attributes[:location], expertise: profile_attributes[:expertise], web_site: profile_attributes[:web_site], testimonials: profile_attributes[:testimonials], additional: profile_attributes[:additional]
			@profile.save

			redirect_to admin_expert_path @expert
		end

		def permitted_params
			# params.permit expert: [:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials]
			params.permit expert: [:name, :first_name, :last_name, :password, :email, :profile]
		end
	end
end
