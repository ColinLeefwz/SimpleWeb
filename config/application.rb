# coding: utf-8

require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require "ripple/railtie"
require 'uuid'

$xmpp_ips = ["42.120.60.200","42.121.98.157","42.121.0.193","42.121.0.192"]
$web_ips = ["42.121.252.94","42.121.79.210","42.121.79.211"]
$xmpp_ip = $xmpp_ips[0]
$web_ip = $web_ips[1]
$gfuid = "507f6bf3421aa93f40000005"
$uuid = UUID.new
$LOG = Logger.new('log/sina_api.log', 0, 100 * 1024 * 1024)

$llcf = 21828775 #脸脸茶坊
$zjkjcyds = 20325453 #浙江科技产业大厦

  $kxs = ["502e6303421aa918ba000001","5032e88d421aa91a1e000016","50446058421aa92042000002","50bc20fcc90d8ba33600004b","502e6303421aa918ba000079"].to_set

$sina_api_key = "2054816412"  
$sina_api_key_secret = "75487227b4ada206214904bb7ecc2ae1"  
$sina_callback = "http://www.dface.cn/oauth2/sina_callback"
$sina_token = '2.00t9e5PCMcnDPC86e7068cc9yxaMRC'

$qq_api_key = "100379223"  
$qq_api_key_secret = "3cc1b95d92352d1335eadc7aea01428f"  


# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Lianlian
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    config.filter_parameters += [:password]
    
    config.generators do |g|  
      g.stylesheets false  
      g.assets false
      #g.orm :active_record
    end
    
  end
end
