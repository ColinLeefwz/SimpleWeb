# coding: utf-8
require 'test_helper'

class Photo2Test < ActionDispatch::IntegrationTest
  
  def upload_photo
    file = 'public/images/test/test.jpg'
    post "/photo2s/create",{:photo => {
      :img => Rack::Test::UploadedFile.new(file, "image/jpeg"),
      :to_uid => '502e6303421aa918ba000005'
      }
    }
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
    
    #测试发送私人xmpp的图片消息, 看mod_rest的ip限制是否配置正确。
    ips = [ "60.191.119", "122.235.240", "42.121.79" ]
    ip = `curl -s ifconfig.me`
    ipc = ip[0,ip.rindex(".")]
    allow_ip = !ips.find_index(ipc).nil?
    fail = false
    begin
      CarrierWave::Workers::StoreAsset.perform("Photo2",Photo2.last._id.to_s,"img")
    rescue RestClient::NotAcceptable
      fail = true
    end
    raise "allow_ip:#{ip},but fail." if allow_ip && fail
#    raise "not allow_ip:#{ip},but not fail." if !allow_ip && !fail  
  end
  
  test "测试api/room接口" do
    Xmpp.test
  end  

  
end
