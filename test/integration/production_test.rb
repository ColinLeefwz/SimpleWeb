# coding: utf-8
require 'test_helper'

class ProductionTest < ActionDispatch::IntegrationTest
  

  def aliyun_tst
    raise "Not set ALIYUN_ACCESS_ID in env" unless ENV["ALIYUN_ACCESS_ID"]
    conn=CarrierWave::Storage::Aliyun::Connection.new({
      aliyun_access_id:ENV["ALIYUN_ACCESS_ID"],
      aliyun_access_key:ENV["ALIYUN_ACCESS_KEY"],
      aliyun_bucket:"dface"
      })
    tstr=Time.now.to_i.to_s
    conn.put(tstr+`hostname`[0..-2] , "Test#{tstr}")
  end
  
  def location_js_tst #不再使用js进行定位
    out = `mongo --quiet dface test/mongo/location.js`
    assert_equal out.length, 0 
  end
  
  def mongoid_tst
    (1..10).each do |x|
      user = User.new
      user.id = x
      user.wb_uid = x
      user.save!     
    end
    (1..10).each do |x|
      user = User.find(x)
      assert_equal x, user.id
    end
    (1..10).each do |x|
      user = User.find(x)
      user.delete
    end
    (1..10).each do |x|
      user = SinaUser.new
      user.id = x
      user.save!     
    end
    (1..10).each do |x|
      user = SinaUser.find(x)
      assert_equal x, user.id
    end
    (1..10).each do |x|
      user = SinaUser.find(x)
      user.delete
    end
    Mongoid.default_session.command(eval:"db.shops.count()")["retval"]
    Mongoid.session(:dooo).command(eval:"db.shops.count()")["retval"]  
  end
  
  test "实际部署的生产系统上测试" do
    if `ifconfig eth0`.to_s.index("inet addr:10") && `ifconfig eth1`.to_s.index("inet addr:42")
      puts "本机器是生产系统"
      aliyun_tst
      mongoid_tst
    else
      mongoid_tst
    end
  end  
  
end
