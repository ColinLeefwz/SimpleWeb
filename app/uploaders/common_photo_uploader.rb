# encoding: utf-8

class CommonPhotoUploader < CarrierWave::Uploader::Base

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

  def extension_white_list
    %w(jpg jpeg gif png cache2)
  end
end
