namespace :category do

  desc "change categories from attributes to association"
  task :associate => :environment do
    puts "clean Categorization talbe"
    Categorization.delete_all
    puts "end clean table"

    %w(Article Announcement VideoInterview Course).each do |model|
      model.constantize.all.each do |instance|
        instance.categories.each do |c|
          category = Category.find_by name: c
          Categorization.create(category_id: category.id, categoriable: instance) unless category.nil?
        end
      end
    end

  end
end
