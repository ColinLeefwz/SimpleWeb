# encoding: utf-8

class LogoUploader < CommonPhotoUploader

  def aliyun_bucket; "logo"+bucket_suffix ; end
  
  process :resize_to_limit => [640, 640]

  version :t2 do
    process :resize_to_fit => [200, 200]
    process :quality => 100
  end 
  
  version :t1 do
    process :resize_to_fit => [100, 100]
    process :quality => 100
  end

  def extension_white_list
    %w(jpg jpeg gif png cache2)
  end
end
