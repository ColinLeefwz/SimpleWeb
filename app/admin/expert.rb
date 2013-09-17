ActiveAdmin.register Expert do

  index do
    column :name do |expert|
      link_to(expert.name, admin_expert_path(expert))
    end
    column "Avatar", :image_url do |expert|
      link_to image_tag(expert.avatar.url, width: "50"), admin_expert_path(expert)
    end
    column :title
    column :company
    column :location
    column :email
    default_actions
  end


  form do |f|
    f.inputs do
      f.input :name
      f.input :avatar, as: :file
      f.input :email
      f.input :title
      f.input :company
      f.input :location
      f.input :expertise
      f.input :web_site
      f.input :testimonials
      f.input :additional
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
      row :title
      row :company
      row :location
      row :expertise
      row :web_site
      row :testimonials
      row :additional
    end
  end


  controller do
    def permitted_params
      params.permit expert: [:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials]
    end
  end
end
