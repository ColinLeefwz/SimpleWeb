ActiveAdmin.register Expert do

  index do
    column :name do |expert|
      link_to(expert.name, admin_expert_path(expert))
    end
    column "Avatar", :image_url do |expert|
      link_to image_tag(expert.avatar.url, width: "50"), admin_expert_path(expert)
    end
    column :title do |e|
      e.expert_profile.title
    end

    column :company do |e|
      e.expert_profile.company
    end

    column :location do |e|
      e.expert_profile.location
    end

    column :email
    default_actions
  end


  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :avatar, as: :file
      f.input :email
      f.input :password, as: :password if f.object.new_record?

      f.inputs name: "Profile", for: [ f.object.expert_profile || ExpertProfile.new ] do |p|
        p.input :title
        p.input :company
        p.input :location
        p.input :expertise
        p.input :web_site
        p.input :testimonials
        p.input :additional
      end

      f.actions
    end
  end


  show do |expert|
    attributes_table do
      row :name
      row :avatar do
        image_tag expert.avatar.url, width: "70"
      end
      row :email
      row :title do |expert|
        expert.expert_profile.title
      end

      row :company do |expert|
        expert.expert_profile.company
      end

      row :location do |expert|
        expert.expert_profile.location
      end

      row :expertise do |expert|
        expert.expert_profile.expertise
      end

      row :web_site do |expert|
        expert.expert_profile.web_site
      end

      row :testimonials do |expert|
        expert.expert_profile.testimonials
      end

      row :additional do |expert|
        expert.expert_profile.additional
      end
    end
  end


  controller do
    def permitted_params
      params.permit expert: [:name, :avatar, :first_name, :last_name, :password, :email, expert_profile: [:title, :company, :location, :expertise, :web_site, :testimonials, :additional] ] 
    end
  end
end
