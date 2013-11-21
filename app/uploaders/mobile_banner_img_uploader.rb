# encoding: utf-8

class MobileBannerImgUploader < CommonPhotoUploader

  def aliyun_bucket; "dface"+bucket_suffix ; end

  process :resize_to_limit => [640, 270]

  version :t2 do
    process :resize_to_fit => [192, 81]
    process :quality => 100
  end 
end
