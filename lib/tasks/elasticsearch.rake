
namespace :elasticsearch do
  desc "import data into elastic"

  task :import => :environment do
    Announcement.import
    Article.import
    VideoInterview.import
    Course.import
    Chapter.import
    Section.import
  end
end
