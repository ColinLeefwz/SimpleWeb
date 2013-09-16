ActiveAdmin.register Expert do

  index do
    column :name do |expert|
      link_to(expert.name, admin_expert_path(expert))
    end
    column "Avatar", :image_url do |expert|
      image_tag(expert.image_url, size: "50x50")
    end
    column :title
    column :company
    column :location
    column :email
    default_actions
  end


  controller do
    def permitted_params
      params.permit expert: [:name, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials]
    end
  end
end
