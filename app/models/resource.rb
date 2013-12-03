class Resource < ActiveRecord::Base
  belongs_to :expert
  has_attached_file :attached_file,
    storage: :s3,
    s3_credentials: Rails.configuration.aws,
    path: ":class/:attachment/:id/:style/:filename"

  scope :video, lambda{ where("attached_file_content_type like ?", "__d_o%" )}

  private

  def self.copy_and_delete(paperclip_file_path, raw_source)
    s3 = AWS::S3.new
    destination = s3.buckets["prodygia-dev"].objects[paperclip_file_path]  #todo use Rails.configuration
    sub_source = CGI.unescape(raw_source)
    sub_source = sub_source.split("/")
    2.times{ sub_source.shift() }
    sub_source = sub_source.join("/")
    source = s3.buckets["prodygia-dev"].objects["#{sub_source}"]
    source.copy_to(destination)
    source.delete
  end
end
