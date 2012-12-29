UserLogo.all.each do |x|
  next if x.img_tmp.nil? || x.img_tmp.length==0
  begin
  	CarrierWave::Workers::StoreAsset.perform("UserLogo",x.id.to_s,"img")
  rescue Exception => e
  	puts e
  end
end

UserLogo.all.each do |x|
  next if x.img_tmp.nil? || x.img_tmp.length==0
  puts x.img_tmp
end