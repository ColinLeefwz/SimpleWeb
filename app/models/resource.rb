class Resource < ActiveRecord::Base
  # validates :attached_file_file_path, :attached_file_file_name, :direct_upload_url, presence: true, allow_blank: false
  # validates :video_definition, inclusion: {in: %w(SD HD)}
  belongs_to :expert
  has_attached_file :attached_file,
    storage: :s3,
    s3_credentials: {
      bucket: ENV["AWS_BUCKET"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    },
    s3_host_name: "s3-us-west-1.amazonaws.com",
    path: ":class/:attachment/:id/:style/:filename"

    scope :video, lambda{ where("attached_file_content_type like ?", "__d_o%" )}

    after_save :copy_and_delete

    private

    def copy_and_delete

      if self.attached_file_file_name.present?
        paperclip_file_path = "resources/attached_files/#{self.id}/original/#{self.attached_file_file_name}"
        raw_source = self.attached_file_file_path

        s3 = AWS::S3.new
        bucket_name = ENV["AWS_BUCKET"]

        destination = s3.buckets[bucket_name].objects[paperclip_file_path]

        sub_source = CGI.unescape(raw_source)
        sub_source = sub_source.split("/")
        2.times{ sub_source.shift() }
        sub_source = sub_source.join("/")

        source = s3.buckets[bucket_name].objects["#{sub_source}"]

        if source.exists?
          source.copy_to(destination)
          source.delete
        end
      end
    end
end
