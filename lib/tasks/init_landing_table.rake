namespace :landingitem do
  desc "init landing_items table"

  task :init => :environment do
    puts "clear Landing_items table"
    Landingitem.delete_all
    puts "end cleaning"

    %w{Article VideoInterview Announcement Course}.each do |klazz|
      klazz.constantize.all.each do |item|
        Landingitem.add_record(item)
      end
    end
  end
end
