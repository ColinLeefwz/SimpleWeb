# encoding: utf-8

class PhotoUploader < CommonPhotoUploader

  def aliyun_bucket; "dface"+bucket_suffix ; end
  
  process :resize_to_limit => [640, 640]

  version :t2 do
    process :resize_to_fit => [200, 200]
    process :quality => 100
  end

  def self.temp_resize (hash)
    old_processors =  self.processors.dup
    begin
      self.processors.reject!{|pro|  hash.keys.include?(pro[0]) }
      process hash
      yield
    ensure
      self.processors = old_processors
    end
  end

end
