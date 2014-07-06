User.where({auto:true}).each do |user|
  begin
    CarrierWave::Workers::StoreAsset.perform("UserLogo",user.head_logo_id.to_s,"img")
  rescue Exception => e
	puts e
  	puts e.backtrace
	puts "\n\n"
  end
end


