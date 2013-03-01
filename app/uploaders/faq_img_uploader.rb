# encoding: utf-8

class FaqImgUploader < CarrierWave::Uploader::Base

  def aliyun_bucket; "dface"+bucket_suffix ; end

  process :resize_to_limit => [640, 640]

  version :t2 do
    process :resize_to_fit => [200, 200]
    process :quality => 100
  end 
end
