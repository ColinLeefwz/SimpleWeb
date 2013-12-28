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
    Mongoid.default_session.command(eval:"db.shops.count()")["retval"]
  end
  
  def xmpp_tst
    ShopFaq.last.send_to_room("502e6303421aa918ba000001")
    Xmpp.send_chat("507f6bf3421aa93f40000005","502e6303421aa918ba000001","Msg,Time,Hose,Port,Username,Password,Resourse,Exception:\nconnectException:,2013年12月28日 15时51分22秒,42.120.60.200,5222,null,null,null,java.lang.NullPointerException\n\tat org.jivesoftware.smack.XMPPConnection.login(XMPPConnection.java:235)\n\tat cn.dface.service.Smackable.login(Smackable.java:820)\n\tat cn.dface.service.Smackable.connect(Smackable.java:568)\n\tat cn.dface.service.Smackable$1.run(Smackable.java:672)\n\tat java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:390)\n\tat java.util.concurrent.FutureTask.run(FutureTask.java:234)\n\tat java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.access$201(ScheduledThreadPoolExecutor.java:153)\n\tat java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:267)\n\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1080)\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:573)\n\tat java.lang.Thread.run(Thread.java:838)\n")
  end
  
  test "实际部署的生产系统上测试" do
    if `ifconfig eth0`.to_s.index("inet addr:10") && `ifconfig eth1`.to_s.index("inet addr:42")
      puts "本机器是生产系统"
      aliyun_tst
      mongoid_tst
      xmpp_tst
    else
      mongoid_tst
    end
  end  
  
end
