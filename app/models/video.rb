class Video < ActiveRecord::Base
  belongs_to :videoable

  has_attached_file :SD, path: ":class/:attachment/:id/:filename"
  has_attached_file :HD, path: ":class/:attachment/:id/:filename"

  after_save :paperclip_path


  private
  #todo: add Exception Handle
  def paperclip_path

    #SD
    expect_path = "videos/sds/#{self.id}/#{self.SD_file_name}"
    actual_path = get_actual_path(self.SD_file_path)
    copy_and_delete(actual_path, expect_path) if (actual_path != expect_path)

    #HD
    expect_path = "videos/hds/#{self.id}/#{self.HD_file_name}"
    actual_path = get_actual_path(self.HD_file_path)
    copy_and_delete(actual_path, expect_path) if (actual_path != expect_path)
  end

  def copy_and_delete(actual_path, expect_path)
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV["AWS_BUCKET"]]

    destination = bucket.objects[expect_path]
    source = bucket.objects[actual_path]

    source.copy_to(destination)
    source.delete
  end

  def get_actual_path(path)
    path = (CGI.unescape path).split("/")
    2.times{ path.shift() }
    path = path.join("/")
  end
end
