# encoding: utf-8

class LogoUploader < CommonPhotoUploader

  def aliyun_bucket; "logo"+bucket_suffix ; end
  
  process :resize_to_limit => [640, 640]

  version :t2 do
    process :resize_to_fit => [150, 150]
    process :quality => 100
  end 
  
  version :t1 do
    process :resize_to_fit => [75, 75]
    process :quality => 100
  end

end
