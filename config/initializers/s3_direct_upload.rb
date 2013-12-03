Prodygia::Application.config.middleware.delete "JQuery::FileUpload::Rails::Middleware"

S3DirectUpload.config do |c|
  Rails.configuration.aws = YAML.load_file("#{Rails.root}/config/aws.yml")[Rails.env].symbolize_keys!

  c.access_key_id = Rails.configuration.aws[:access_key_id]
  c.secret_access_key = Rails.configuration.aws[:secret_access_key]
  c.bucket = Rails.configuration.aws[:bucket]
end
