# encoding: utf-8
module ControllerName
  Menu = ['用户管理','地点管理','活动管理','签到管理','系统权限','客户端管理','用户统计','商家统计','活动统计','点评统计','个人用户统计']
  Right= {
    0=>{"admin_users"=>"用户列表", "admin_kx_users"=>"可信用户", "admin_user_logos" => '头像审核', "admin_blacks"=>"举报用户", 
      "admin_rekognitions" => "人脸识别"},
    1=>{"admin_shops"=>"地点管理", "admin_user_add_shops"=>"用户添加地点管理", "admin_user_reports"=>"用户地点报错管理",
      "admin_shop_notices"=>"商家公告", "admin_shop_faqs"=>"商家问答", "admin_shop_logos"=>"商家logo",
      "admin_shop_coupons"=>"商家优惠券", "admin_shop_photos"=>"照片墙", "admin_shop_bans"=>"商家屏蔽用户", "admin_shop_bindwbs"=>"商家绑定微博", "admin_shop_signs"=>"合同管理",
      "admin_sina_pois"=>"微博地点", "admin_baidu"=>"百度地点"},
    2=>{"admin_parties"=>"活动管理"},
    3=>{"admin_checkins"=>"签到管理", "admin_gps_logs" => "gps日志"},
    4=>{"admin_login"=>"登录", "admins"=>"管理员管理", "admin_rights"=>"权限管理"},
    5=>{"admin_crash_logs"=>"安卓崩溃管理","admin_versions" => '版本管理'},
    6=>{"admin_user_days"=>"每日新增", "admin_user_hours"=>"每小时新增","user_device_stats"=>"每日注册机型统计",
      "admin_user_city_days"=>"每日城市分布","admin_user_actives" => "用户活跃度"},
    7=>{},
    8=>{"checkin_days"=>"每日签到", "shop_checkin_stats"=>"商家签到统计",
      "user_checkin_stats"=>"用户签到统计", "ip_checkin_stats"=>"ip签到统计", "shop_checkin_alts"=>"签到高度统计",
      "checkin_loc_accs"=>"经纬度误差统计", "checkin_user_many"=>"多次签到"},
    9=>{},
    10=>{}
  }
end
