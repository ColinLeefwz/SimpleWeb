# coding: utf-8
require 'test_helper'

class Photo2Test < ActionDispatch::IntegrationTest
  
  def upload_photo
    file = 'public/images/test/测试图.jpg'
    post "/photo2s/create",{:photo => {
      :img => Rack::Test::UploadedFile.new(file, "image/jpeg"),
      :to_uid => '502e6303421aa918ba000005'
      }
    }
  end
  
  def async_process_photo
    CarrierWave::Workers::StoreAsset.perform("Photo",Photo.last._id.to_s,"img")
  end

  test "个人聊天上传图片" do
    reload('users.js')
    #未登录时上传图片
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"
    #登录
    get "/oauth2/test_login?id=502e6303421aa918ba000001"
    assert_equal User.find("502e6303421aa918ba000001").id, session[:user_id]
    
        
    #上传图片
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], Photo2.last.id.to_s
    assert_equal Photo2.last.to_uid.to_s, "502e6303421aa918ba000005"
    assert_equal Photo2.last.user_id.to_s, "502e6303421aa918ba000001"
    
    #测试发送私人xmpp的图片消息
    Photo2.last.after_async_store
    
  end
  
  test "测试api/room接口" do
    RestClient.post("http://#{$xmpp_ip}:5280/api/room", 
        :roomid  => "4928288" , :message=> "测试一下" ,
        :uid => "502e6303421aa918ba000001") 
  end  

  test "实际部署的生产系统上测试阿里云文件上传" do
    if `ifconfig eth1`.to_s.length > 0
      raise "Not set ALIYUN_ACCESS_ID in env" unless ENV["ALIYUN_ACCESS_ID"]
      conn=CarrierWave::Storage::Aliyun::Connection.new({
        aliyun_access_id:ENV["ALIYUN_ACCESS_ID"],
        aliyun_access_key:ENV["ALIYUN_ACCESS_KEY"],
        aliyun_bucket:"dface"
        })
      tstr=Time.now.to_i.to_s
      conn.put(tstr+`hostname`,"Test#{tstr}")
    end
  end  
  
end