namespace :expert do

  desc "reset all expert's password"
  task :set_pwd => :environment do
    Expert.all.each do |exp|
      exp.update_attributes password: "logintochina"
    end
  end

end
