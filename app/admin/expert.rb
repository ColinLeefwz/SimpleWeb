ActiveAdmin.register Expert do

  action_item only:[:index] do
    link_to 'Invit An Expert', new_user_invitation_path
  end

  index do
    column :name do |expert|
      link_to(expert.name, admin_expert_path(expert))
    end
    column "Avatar", :image_url do |expert|
      link_to image_tag(expert.avatar.url, width: "50"), admin_expert_path(expert)
    end
    column :title do |e|
      e.profile.title
    end

    column :company do |e|
      e.profile.company
    end

    column :location do |e|
      e.profile.location
    end

    column :time_zone

    column :email
    default_actions
  end

  form partial: "form"

  show do |expert|
    attributes_table do
      row :name
      row :avatar do
        image_tag expert.avatar.url, width: "70"
      end
      row :email
      row :time_zone
      row :title do |expert|
        expert.profile.title
      end

      row :company do |expert|
        expert.profile.company
      end

      row :twitter do |expert|
        expert.profile.twitter
      end

      row :web_site do |expert|
        expert.profile.web_site
      end

      row :location do |expert|
        expert.profile.location
      end

      row :expertise do |expert|
        expert.profile.expertise
      end

      row :web_site do |expert|
        expert.profile.web_site
      end

      row :testimonials do |expert|
        expert.profile.testimonials
      end

      row :additional do |expert|
        expert.profile.additional
      end
    end
  end


  controller do
    def new
      @expert = Expert.new
      @expert.build_intro_video
      @expert.build_profile
    end

    def edit
      @expert = Expert.find params[:id]
      @expert.intro_video || @expert.create_intro_video
      @expert.profile || @expert.create_profile
    end

    def permitted_params
      params.permit(:id, :commit, :authenticity_token, expert: [:id, :name, :avatar, :first_name, :last_name, :password, :email, :time_zone, profile_attributes: [:id, :title, :company, :location, :country, :city, :expertise, :web_site, :testimonials, :additional, :career, :education, :twitter], intro_video_attributes: [:id, :attached_video_hd_file_name, :attached_video_hd_content_type, :attached_video_hd_file_size, :attached_video_sd_file_name, :attached_video_sd_content_type, :attached_video_sd_file_size, :sd_url, :hd_url, :cover]])
    end
  end
end
