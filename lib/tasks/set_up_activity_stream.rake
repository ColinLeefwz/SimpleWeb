namespace :activity_stream do

  desc "create activity stream for existing user"
  task :set_up => :environment do
    User.all.each do |u|
      ActivityStream.find_or_create_by user_id: u.id
    end

    puts "*** success ***"
  end
end
