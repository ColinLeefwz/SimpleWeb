# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include ::CarrierWave::Backgrounder::Delay

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
    process :quality => 100
  end 
  
  version :t1 do
    process :resize_to_fit => [75, 75]
    process :quality => 100
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
