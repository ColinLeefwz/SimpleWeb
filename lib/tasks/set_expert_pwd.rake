namespace :expert do
  desc "set some expert attributes"

  task :set_pwd => :environment do
    Expert.all.each do |exp|
      exp.update_attributes password: "logintochina"
    end
  end
end
