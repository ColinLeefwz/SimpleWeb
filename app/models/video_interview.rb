class VideoInterview < ActiveRecord::Base
	belongs_to :expert

	has_attached_file :attached_video,
    storage: :s3,
		s3_credentials: {
			bucket: ENV["AWS_BUCKET"],
			access_key_id: ENV["AWS_ACCESS_KEY_ID"],
			secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
		},
    path: ":class/:attachment/:id/:style/:filename"
end
