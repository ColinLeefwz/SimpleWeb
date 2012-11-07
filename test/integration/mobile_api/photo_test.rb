# coding: utf-8
require 'test_helper'

class PhotoTest < ActionDispatch::IntegrationTest
  
  def upload_photo
    file = 'public/images/test/测试图.jpg'
    post "/photos/create",{:photo => {
      :img => Rack::Test::UploadedFile.new(file, "image/jpeg"),
      :room => 12,
      :weibo => 0,
      :desc => '一张图片'
      }
    }
  end
  
  def async_process_photo
    CarrierWave::Workers::StoreAsset.perform("Photo",Photo.last._id.to_s,"img")
  end

  test "聊天室上传图片" do
    reload('users.js')
    
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"
    
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]
    
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], Photo.last.id.to_s
    assert_equal data["room"], "12"
    assert_equal data["weibo"], false
    assert_equal data["desc"],  '一张图片'
    assert_nil data["logo_thumb2"]
    assert !Photo.last.img_tmp.nil?
    async_process_photo
    assert Photo.last.img_tmp.nil?
    assert Photo.last.img.url(:t2).index(Photo.last.id.to_s)>0
  end

end