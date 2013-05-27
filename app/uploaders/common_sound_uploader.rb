# encoding: utf-8

class CommonSoundUploader < CarrierWave::Uploader::Base

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
    "0.aac" if original_filename
  end

  def extension_white_list
    %w(aac amr cache2)
  end
end
