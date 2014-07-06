# encoding: utf-8

class CouponUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :aliyun
  
  def store_dir
    "#{model.id}"
  end
  
  def aliyun_bucket
    return "coupon" if ENV["RAILS_ENV"] == "production"
    return "coupon-test" 
  end
  
  def filename
    "0.jpg" if original_filename
  end

  process :resize_to_fit => [580, 224]
  
  version :t1 do
    process :resize_to_fit => [290,112]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
