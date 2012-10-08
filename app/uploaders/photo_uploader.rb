# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :aliyun
  
  def bucket_suffix
    return "" if ENV["RAILS_ENV"] == "production"
    return "_test"
  end
  
  def store_dir
    "#{model.id}"
  end
  
  def filename
    "0.jpg" if original_filename
  end

  process :resize_to_limit => [640, 640]

  version :t2 do
    process :resize_to_fit => [150, 150]
  end 
  
  version :t1, :from_version => :t2 do
    process :resize_to_fit => [75, 75]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
