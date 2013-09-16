ActiveAdmin.register Expert do
  controller do
    def permitted_params
      params.permit expert: [:name, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials]
    end
  end
end
