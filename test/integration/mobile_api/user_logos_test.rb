# coding: utf-8
require 'test_helper'

class UserLogosTest < ActionDispatch::IntegrationTest

  test "上传图片,查看相册,删除图片,更改位置" do
    reload('users.js')
    UserLogo.delete_all
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]
    assert_equal User.find("502e6303421aa918ba000005").pcount, 0

    #上传图片
    file = 'public/images/test/测试图.jpg'
    post "/user_logos/create",{:user_logo => {:img => Rack::Test::UploadedFile.new(file, "image/jpeg")}, :user_id => session_user.id}
    assert_response :success
    assert_present session_user.user_logos
    data = JSON.parse(response.body)
    assert_present data['logo']

    #获取用户的图片列表
    get "/user_info/photos?id=#{session_user.id}"
    assert_response :success
    data = JSON.parse(response.body)
    assert data.length == 1

    #上传多张图片
    post "/user_logos/create",{:user_logo => {:img => Rack::Test::UploadedFile.new('public/images/test/coupon.jpg', "image/jpeg")}, :user_id => session_user.id}
    post "/user_logos/create",{:user_logo => {:img => Rack::Test::UploadedFile.new('public/images/test/sendpix0.jpg', "image/jpeg")}, :user_id => session_user.id}
    one,two,three = UserLogo.where({:user_id => session_user.id}).sort({:_id => 1}).to_a

    #获取用户的图片列表
    get "/user_info/photos?id=#{session_user.id}"
    assert_response :success 
    data = JSON.parse(response.body)
    assert_equal  data.map{|d| d['id']}, [one.id.to_s, two.id.to_s, three.id.to_s]
    assert_equal 3, session_user.pcount

    #改变图片位置
    get "/user_logos/change_all_position?ids=#{two.id.to_s},#{three.id.to_s},#{one.id.to_s}"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal  data.map{|d| d['id']}, [two.id.to_s, three.id.to_s, one.id.to_s]

    #用户头像
    get "/user_info/logo?id=#{session_user.id}"
    assert_response :redirect
    assert_redirected_to UserLogo.find(session_user.head_logo_id).img.url

    #删除一个图片
    get "/user_logos/delete?id=#{one.id}"
    assert_response :success
    assert_equal session_user.user_logos.to_a,[two, three]
    assert_equal session_user.head_logo_id, two.id
    assert_equal 2, session_user.pcount

    #删除二个图片
    get "/user_logos/delete?id=#{two.id}"
    assert_response :success
    assert_equal session_user.user_logos.to_a,[three]
    assert_equal session_user.head_logo_id, three.id
    assert_equal 1, session_user.pcount
    
    #删除最后一张图片
    get "/user_logos/delete?id=#{three.id}"
    assert_response :success
    data = JSON.parse(response.body)
    error= {"error" => "must have at least one photo"}
    assert_equal error , data
    assert_equal session_user.user_logos.to_a,[three]

  end

end