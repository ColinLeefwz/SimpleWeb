# encoding: utf-8

class ShopSignUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  storage :aliyun
 
  def aliyun_bucket
    return "lianlian" if ENV["RAILS_ENV"] == "production"
    return "coupon-test"
  end

  process :set_content_type

  def store_dir
    "#{model.id}"
  end

  def filename
    if original_filename
      "0."+ original_filename.split('.').last
    end
  end

#  def extension_white_list
#    %w(doc zip gz)
#  end

end
