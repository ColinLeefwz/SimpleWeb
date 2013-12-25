module Storagable
	extend ActiveSupport::Concern

	included do
	end

	module ClassMethods
		def attached_file(file_name, styles={}) 
			styles_value = styles[:styles] || {}
			has_attached_file file_name,
				storage: :s3,
				s3_credentials: {
					bucket: ENV["AWS_BUCKET"],
					access_key_id: ENV["AWS_ACCESS_KEY_ID"],
					secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
				},
				s3_host_name: "s3-us-west-1.amazonaws.com",
				path: ":class/:attachment/:id/:style/:filename",
				styles: styles_value,
				default_url: "https://s3-us-west-1.amazonaws.com/#{ENV["AWS_BUCKET"]}/images/missing.png" ## here we can add method, if we want different pic for default http://rubydoc.info/gems/paperclip/Paperclip/ClassMethods#has_attached_file-instance_method
		end

	end

end
