class Resource < ActiveRecord::Base
  validates :attached_file_file_path, :attached_file_file_name, :direct_upload_url, presence: true, allow_blank: false
  belongs_to :expert
  has_attached_file :attached_file,
    storage: :s3,
		s3_credentials: {
			bucket: ENV["AWS_BUCKET"],
			access_key_id: ENV["AWS_ACCESS_KEY_ID"],
			secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
		},
    path: ":class/:attachment/:id/:style/:filename"

  scope :video, lambda{ where("attached_file_content_type like ?", "__d_o%" )}

  private

  def self.copy_and_delete(paperclip_file_path, raw_source)
    s3 = AWS::S3.new
    bucket_name = Rails.configuration.aws[:bucket]

    destination = s3.buckets[bucket_name].objects[paperclip_file_path]
    
    sub_source = CGI.unescape(raw_source)
    sub_source = sub_source.split("/")
    2.times{ sub_source.shift() }
    sub_source = sub_source.join("/")

    source = s3.buckets[bucket_name].objects["#{sub_source}"]
    source.copy_to(destination)
    source.delete
  end
end
