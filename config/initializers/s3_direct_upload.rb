Prodygia::Application.config.middleware.delete "JQuery::FileUpload::Rails::Middleware"

S3DirectUpload.config do |c|
  c.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
  c.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
  c.bucket = ENV["AWS_BUCKET"]
  # c.region = "s3-"+ENV["AWS_REGION"]
  c.region = "s3-us-west-1"
end
