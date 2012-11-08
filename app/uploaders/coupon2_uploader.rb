# encoding: utf-8

class Coupon2Uploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file
  
  def store_dir
    "coupon/#{model.id}"
  end
  
  def filename
    "0.jpg" if original_filename
  end


  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
