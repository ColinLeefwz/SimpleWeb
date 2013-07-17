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

#旅行团
$travel=[21832384]

#7月18日  合作框架广告推送楼宇地点
$mansion1 = [20297588,21833286,10437415,20344589,
  10442142,10447101,21833609,20297721,20297831,20338155,
  20297832,7043994,20297708,20325453,20297552,
  6544448,10462223,10434468,20324623,21833620,20325399,21828719,20325475,
  10453425,20325313,2033286,20297541,20325425,10436966]
#7月18日  重点推送楼宇地点
$mansion2 = [20297536,20325455,21833626,20297628,20325398,10434661,20344567,20297735,
  20297534,20325478,20325454,20297710,10447108,10452118,10443607,10412686,
  10415679,21833701,20325394,20298195,6517315,20325438,20297694,10440563,
  20297810,20325312,20344565,20344552]
#7月18日  合作商家
$cooperation_shops = [21833121,21832395,21617616,1203908,
  1217422,21618279,21832993,1204513,1204520,
  21616891,6564061,21619457,21828387,
  21615523,21625070,21616160,21833151,
  21615581,21829139,21830285,21616609,1227224,1229283,
  21625903,21616840,21833289,21833623,21624812,21833354,
  21833342,21617846,21617897,21626213,21830697,21626809,21833416]


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
