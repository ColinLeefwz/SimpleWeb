# encoding: utf-8
class AndroidUpload
  @queue = :normal

  def self.perform(version)
#    `scp web2:#{path} web1:/mnt/lianlian/public/`
    `ssh web2 "/mnt/Oss/oss2/osscmd put /mnt/lianlian/public/dface#{version}.apk oss://dface/dface${version}.apk --content-type=application/octet-stream"`
  end
  
end