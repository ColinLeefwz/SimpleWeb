# coding: utf-8

require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require 'uuid'

$xmpp_ips = ["42.120.60.200","42.121.98.157","42.121.0.193","42.121.0.192"]
$web_ips = ["42.121.252.94","42.121.79.210","42.121.79.211"]
$xmpp_ip = $xmpp_ips[0]
$web_ip = $web_ips[1]
$gfuid = "507f6bf3421aa93f40000005" #脸脸网络
$dduid = "51418139c90d8bc67b0003bf" #脸脸地点审核
$xpuid = "50bc20fcc90d8ba33600004b" #浦靠谱

$uuid = UUID.new
$LOG = Logger.new('log/sina_api.log', 0, 100 * 1024 * 1024)

$llcf = 21828775 #脸脸茶坊
$llshop = 21830954 #浙江产业大厦11楼脸脸网络
$llsc = 21830325 #脸脸商城
$zjkjcyds = 20325453 #浙江科技产业大厦

$kxs = ["50bec2c1c90d8bd12f000086","519d894dc90d8b83ee000008","502e6303421aa918ba000001","5032e88d421aa91a1e000016","50446058421aa92042000002","50bc20fcc90d8ba33600004b","502e6303421aa918ba000079","50ea8be1c90d8bd530000020","50f15e00c90d8b19230000cc","50dfbcc4c90d8bb84e000061", "5178b595c90d8bdcdb00000b", "512aeb11c90d8ba3020000d0", "51163b3ac90d8b90650001d5","5160f00fc90d8be23000007c","51a4b135c90d8be50b000059"].to_set

$sina_api_key = "2054816412"  
$sina_api_key_secret = "75487227b4ada206214904bb7ecc2ae1"  
$sina_callback = "http://www.dface.cn/oauth2/sina_callback"
$sina_token = '2.00t9e5PCMcnDPC86e7068cc9yxaMRC'

$qq_api_key = "100379223"  
$qq_api_key_secret = "3cc1b95d92352d1335eadc7aea01428f"

$travel=[21832384]

#7月18日活动商家id
$ActiveShops=[21828775,21830785]

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Lianlian
  class Application < Rails::Application

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    
    config.generators do |g|  
      g.stylesheets false  
      g.assets false
      #g.orm :active_record
    end
    
  end
end
