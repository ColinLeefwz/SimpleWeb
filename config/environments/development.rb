Prodygia::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # add fonts to assets
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

  # precompile additional assets
  config.assets.precompile += %w[.svg, .eot .woff .tff]

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  #config default url
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # config.action_mailer.delivery_method = :sendmail
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.default_options = { from: 'no-replay@prodygia.com' }

  # config sending email
  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  # 	address: "smtp.mandrillapp.com",
  # 	port: 587,
  # enable_starttls_auto: true,
  # 	domain: "prodygia.com",
  # 	authentication: "login",
  # 	enable_starttls_auto: true,
  # 	user_name: ENV['MANDRILL_USERNAME'],
  # 	password: ENV["MANDRILL_API"]
  # }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  Paperclip.options[:command_path] = "/usr/bin/"

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      bucket: ENV["AWS_BUCKET"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    },
    s3_host_name: "s3-us-west-1.amazonaws.com",
    path: ":class/:attachment/:id/:style/:filename",
    default_url: "https://s3-us-west-1.amazonaws.com/#{ENV["AWS_BUCKET"]}/images/missing.png" 
  }

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = {:host => 'localhost:3000'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address => 'smtp.gmail.com',
    :port => 587,
    :domain => 'gmail.com',
    :authentication => :login,
    :user_name => 'Your_gmail_account',
    :password => 'Your_password'
  }

end
