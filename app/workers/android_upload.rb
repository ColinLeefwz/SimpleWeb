# encoding: utf-8
class AndroidUpload
  @queue = :normal

  def self.perform(path)
    `scp #{path} web1:/mnt/lianlian/public/`
  end
  
end