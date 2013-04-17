# encoding: utf-8

class ShopSignUploader < CarrierWave::Uploader::Base
  storage :aliyun
 
  def aliyun_bucket
    return "lianlian" if ENV["RAILS_ENV"] == "production"
    return "coupon_test"
  end

  def store_dir
    "#{model.id}"
  end

  def filename
    "0.doc" if original_filename
  end

  def extension_white_list
    %w(doc)
  end

end
