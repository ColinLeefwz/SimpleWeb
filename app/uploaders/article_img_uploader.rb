# encoding: utf-8

class ArticleImgUploader < CommonPhotoUploader

  def aliyun_bucket; "dface"+bucket_suffix ; end

  process :resize_to_limit => [640, ""]
  
end
