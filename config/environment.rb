<<<<<<< HEAD
# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Prodygia::Application.initialize!
=======
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
>>>>>>> b8c272e31d97492bb030400d7034cb2d7a03ce34
