namespace :category do

  desc "change categories from attributes to association"
  task :associate => :environment do

    %w(Article Announcement VideoInterview Course).each do |model|
      model.constantize.all.each do |instance|
        instance.categories.each do |c|
          category = Category.find_by name: c
          Categorization.create(category_id: category.id, categoriable: instance)
        end
      end
    end

  end
end
