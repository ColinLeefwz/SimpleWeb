class Video < ActiveRecord::Base
  belongs_to :videoable, polymorphic: true

  has_attached_file :cover
  has_attached_file :SD, path: ":class/:attachment/:id/:filename"
  has_attached_file :HD, path: ":class/:attachment/:id/:filename"

  after_save :paperclip_path


  private
  #todo: add Exception Handle
  def paperclip_path
    bucket = get_bucket

    %w(SD HD).each do |definition|
      raw_path = get_raw_path(self.send(definition+"_file_path"))
      object = bucket.objects[raw_path]

      if object.exists?
        object.copy_to get_destination(definition)
        object.delete
      end
    end
  end


  def get_bucket
    return @bucket if defined?(@bucket)
    s3 = AWS::S3.new
    @bucket = s3.buckets[ENV["AWS_BUCKET"]]
  end


  def get_raw_path(path)
    path = (CGI.unescape path).split("/")
    2.times{ path.shift() }
    path = path.join("/")
  end


  def get_destination(definition)
    expect_path = "videos/#{definition.downcase.pluralize}/#{self.id}/#{self.send(definition+'_file_name')}"
    bucket = get_bucket
    destination = bucket.objects[expect_path]
  end

end

