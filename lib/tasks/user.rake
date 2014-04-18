namespace :user do
  desc "set the user names"
  task :set_user_name => :environment do
    User.all.each do |u|
      u.update_attributes user_name: u.send(:set_user_name)
    end
  end

  desc "reset user pwd"
  task :set_pwd, [:email, :new_pwd] => :environment do |t, args|
    user = User.find_by email: args.email
    if user
      user.update_attributes(password: args.new_pwd)
      puts "updated pwd for user: #{args.email}"
    else
      puts "not found the user"
    end
  end

end
