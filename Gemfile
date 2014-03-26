source 'http://rubygems.org'

gem 'rails', '~> 3.2'
gem "iconv", "~> 1.0.3" #added this in your Gemfile

# Deploy with Capistrano
# gem 'capistrano'

gem 'debugger'

group :production do
  gem 'unicorn', '~> 4.3'
  gem 'unicorn-worker-killer'
  gem 'god'
  gem 'puma'
  gem 'newrelic_rpm'
end

group :development do
  gem 'osmlib-base'
  gem "wirble"
  gem 'xmpp4r'
  gem "selenium-webdriver"
end

group :test do
  gem "selenium-webdriver"
end

#gem 'rack', '~> 1.4'
gem "oauth2"
#gem "will_paginate"
gem "in_place_editing"
gem 'bson_ext'
gem 'mongoid', '~> 3.1.0'
gem 'rails-i18n'
gem 'redis'
gem 'redis-store'
gem 'redis-rails'
gem 'uuid'

gem 'carrierwave'
gem 'mini_magick'
gem 'rest-client'
gem 'carrierwave-aliyun'#, :git => "git://github.com/yuanxinyu/carrierwave-aliyun.git"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'carrierwave_backgrounder', :git => "git://github.com/yuanxinyu/carrierwave_backgrounder.git"

gem 'resque', :require => "resque/server"
gem 'resque-scheduler', :require => 'resque_scheduler'

#gem 'ripple', '~> 1.0.0.beta2'
gem 'rake', '~> 10.0.1'
gem 'dalli'

gem 'qiniu-rs', :git => "https://github.com/qiniu/ruby-sdk.git"

