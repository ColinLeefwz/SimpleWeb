json.array!(@experts) do |expert|
  json.extract! expert, :name, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials
  json.url expert_url(expert, format: :json)
end
