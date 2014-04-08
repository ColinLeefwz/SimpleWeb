namespace :user do
  desc "get the user names"
  task :set_user_name => :environment do
    User.all.each do |u|
      u.update_attributes user_name: u.send(:set_user_name)
    end

  end

end
