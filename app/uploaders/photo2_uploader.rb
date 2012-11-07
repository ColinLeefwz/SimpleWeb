# encoding: utf-8

class Photo2Uploader < CommonPhotoUploader

  def aliyun_bucket; "dface2"+bucket_suffix ; end
  
  process :resize_to_limit => [640, 640]

  version :t2 do
    process :resize_to_fit => [150, 150]
    process :quality => 100
  end 

end
