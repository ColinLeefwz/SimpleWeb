# coding: utf-8
require 'test_helper'

class PhotoTest < ActionDispatch::IntegrationTest
  
  def upload_photo
    file = 'public/images/test/测试图.jpg'
    post "/photos/create",{:photo => {
      :img => Rack::Test::UploadedFile.new(file, "image/jpeg"),
      :room => 4928288,
      :weibo => 0,
      :desc => '一张图片'
      }
    }
  end
  
  def async_process_photo
    CarrierWave::Workers::StoreAsset.perform("Photo",Photo.last._id.to_s,"img")
  end
  
  def do_checkin
    post "/checkins",{
      :lat => 30.28,
      :lng => 120.108,
      :accuracy => 100,
      :shop_id => 4928288,
      :user_id => "502e6303421aa918ba000005",
      :od => 1
    }    
  end

  test "聊天室上传图片" do
    reload('users.js')
    reload('checkins.js')
    #未登录时上传图片
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"
    #登录
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]
    
    assert_difference 'Checkin.count' do
      do_checkin
    end
    
    #上传图片
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], Photo.last.id.to_s
    assert_equal data["room"], "4928288"
    assert_equal data["weibo"], false
    assert_equal data["desc"],  '一张图片'
    assert_nil data["logo_thumb2"]
    assert !Photo.last.img_tmp.nil?
    
    debugger
    assert_equal Photo.last.id, Checkin.last.photos[0]

    #未处理就获得图片
    begin
      get "/photos/show?id=#{Photo.last.id}"
      raise "should throw error"
    rescue
    end
       
    #异步处理图片
    async_process_photo
    assert Photo.last.img_tmp.nil?
    assert Photo.last.img.url(:t2).index(Photo.last.id.to_s)>0
    
    #再次获得图片
    get "/photos/show?id=#{Photo.last.id}"
    assert_response :redirect
    
    
  end

end