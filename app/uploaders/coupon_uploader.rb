# encoding: utf-8

class CouponUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :aliyun
  
  def store_dir
    "#{model.id}"
  end
  
  def aliyun_bucket
    return "coupon" if ENV["RAILS_ENV"] == "production"
    return "coupon_test" 
  end
  
  def filename
    "0.jpg" if original_filename
  end

  process :resize_to_fit => [610, 306]
  
  version :t1 do
    process :resize_to_fit => [305, 153]
  end

  version :t2 do
    process :resize_to_fit => [58, 58]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
