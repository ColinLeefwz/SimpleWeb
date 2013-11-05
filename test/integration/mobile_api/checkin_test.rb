# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class CheckinTest < ActionDispatch::IntegrationTest
  
  #要先运行rake db:mongoid:create_indexes RAILS_ENV=test
  def test_checkin_with_bssid
    reload("checkins.js")
    $redis.keys("BSSID*").each {|key| $redis.del(key)}
    $redis.keys("ckin*").each {|key| $redis.zremrangebyrank(key,0,-1)}
    login("502e6303421aa918ba000001");
    assert_difference 'Checkin.count' do
      post "/checkins",{"user_id"=>"502e6303421aa918ba000001", "ssid"=>"H3Cyuan", "shop_id"=>"1", "altitude"=>"28.416849", "od"=>"1", "altacc"=>"13", "lat"=>"30.279768", "lng"=>"120.108162", "accuracy"=>"95", "bssid"=>"0:23:89:71:6f:c4"}
    end
  end


  def test_checkin_without_bssid
    reload("checkins.js")
    $redis.keys("BSSID*").each {|key| $redis.del(key)}
    $redis.keys("ckin*").each {|key| $redis.zremrangebyrank(key,0,-1)}
    login("502e6303421aa918ba000001");
    assert_difference 'Shop.find(2).checkins.count' do
      post "/checkins",{"user_id"=>"502e6303421aa918ba000001",  "shop_id"=>"2", "altitude"=>"28.416849", "od"=>"1", "altacc"=>"13", "lat"=>"30.279768", "lng"=>"120.108162", "accuracy"=>"95"}
    end
  end

  def test_create_shop
    reload('shops.js')
    reload("checkins.js")
    $redis.keys("BSSID*").each {|key| $redis.del(key)}
    uid = "502e6303421aa918ba000001"
    Rails.cache.delete("ADDSHOP#{uid}")
    $redis.keys("ckin*").each {|key| $redis.zremrangebyrank(key,0,-1)}
    `rake db:mongoid:create_indexes RAILS_ENV=test`
    login("502e6303421aa918ba000001")
    name = "#{Random.rand}"
    assert_difference 'Shop.count' do
      assert_difference 'Checkin.count' do
        $redis.del("SHOP_NID")
        resp = post "/checkins/new_shop",{"user_id"=>uid,  "sname"=>name, "altitude"=>"28.416849", "od"=>"1", "altacc"=>"13", "lat"=>"30.279768", "lng"=>"120.108162", "accuracy"=>"95"}
        assert_response :success
        #puts response.body
      end
    end
    assert_equal Shop.last.name, name
    Shop.last.destroy
  end
    
end