# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class CheckinTest < ActionDispatch::IntegrationTest
  
  #要先运行rake db:mongoid:create_indexes RAILS_ENV=test
  def test_checkin_with_bssid
    login("502e6303421aa918ba000001");
    assert_difference 'Checkin.count' do
      post "/checkins",{"user_id"=>"502e6303421aa918ba000001", "ssid"=>"H3Cyuan", "shop_id"=>"1", "altitude"=>"28.416849", "od"=>"1", "altacc"=>"13", "lat"=>"30.279768", "lng"=>"120.108162", "accuracy"=>"95", "bssid"=>"0:23:89:71:6f:c4"}
    end
  end


  def test_checkin_without_bssid
    login("502e6303421aa918ba000001");
    assert_difference 'Shop.find(2).checkins.count' do
      post "/checkins",{"user_id"=>"502e6303421aa918ba000001",  "shop_id"=>"2", "altitude"=>"28.416849", "od"=>"1", "altacc"=>"13", "lat"=>"30.279768", "lng"=>"120.108162", "accuracy"=>"95"}
    end
  end

  def test_create_shop
    reload('shops.js')
    `rake db:mongoid:create_indexes RAILS_ENV=test`
    login("502e6303421aa918ba000001");
    assert_difference 'Shop.count' do
    assert_difference 'Checkin.count' do
      post "/checkins/new_shop",{"user_id"=>"502e6303421aa918ba000001",  "sname"=>"添加地点1", "altitude"=>"28.416849", "od"=>"1", "altacc"=>"13", "lat"=>"30.279768", "lng"=>"120.108162", "accuracy"=>"95"}
    end
    end
    assert_equal Shop.last.name, "添加地点1"
  end
    
end