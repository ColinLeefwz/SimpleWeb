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


  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :avatar, as: :file
      f.input :email
      f.input :password, as: :password if f.object.new_record?
      f.input :time_zone

      f.inputs name: "Profile", for: [ f.object.profile || Profile.new ] do |p|
        p.input :title
        p.input :company
        p.input :location
        p.input :twitter
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
    def permitted_params
      params.permit expert: [:name, :avatar, :first_name, :last_name, :password, :email, :time_zone, profile: [:title, :company, :twitter, :location, :expertise, :web_site, :testimonials, :additional]]
    end
  end
end
