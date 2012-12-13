# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Lianlian::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.126.com",
  :port => 25,
  :authentication => :login,
  :user_name => "huang123qwe@126.com",
  :password => "364371"
}