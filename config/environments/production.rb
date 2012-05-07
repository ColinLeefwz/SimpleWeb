# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_controller.allow_forgery_protection = false 
config.action_controller.session_store = :mem_cache_store

# Use a different cache store in production
config.cache_store = :mem_cache_store, '127.0.0.1:11211'
#/usr/bin/memcached -m 64 -p 11211 -u nobody -l 127.0.0.1

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.action_mailer.smtp_settings = {
  :address =>  "mail.1dooo.com",
  :port => 25,
  :domain => "mail.1dooo.com",
  :authentication => :login,
  :user_name => "service",
  :password =>   "hz1234",
  }
config.action_mailer.sendmail_settings = { 
    :location       => '/usr/sbin/sendmail', 
    :arguments      => '-i -t' 
}
config.action_mailer.delivery_method = :sendmail

