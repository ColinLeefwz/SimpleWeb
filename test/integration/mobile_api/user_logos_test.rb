# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class UserLogosTest < ActionDispatch::IntegrationTest

  test "上传图片,查看相册,删除图片,更改位置" do
    reload('users.js')
    UserLogo.delete_all

    luser = User.find('502e6303421aa918ba000005')
    user1 = User.find('502e6303421aa918ba00007c')
    file = 'public/images/test/test.jpg'
    file1 = 'public/images/test/coupon.jpg'

    #登录上传图片
    login(luser.id)
    assert_equal User.find("502e6303421aa918ba000005").pcount, 0
    post "/user_logos/create",{:user_logo => {:img => Rack::Test::UploadedFile.new(file, "image/jpeg")}}
    assert_response :success
    assert_equal luser.reload.pcount, 1
    data = JSON.parse(response.body)
    assert_equal data, {"logo"=>UserLogo.first.img.url,"logo_thumb"=> UserLogo.first.img.url(:t1),"logo_thumb2"=> UserLogo.first.img.url(:t2),"id"=>UserLogo.first.id.to_s,"user_id"=>"502e6303421aa918ba000005"}

    #未登录上传图片
    logout
    post "/user_logos/create",{:user_logo => {:img => Rack::Test::UploadedFile.new(file1, "image/jpeg")}}
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal luser.reload.pcount, 1

    #登录获取用户的图片列表
    login(luser.id)
    get "/user_info/photos?id=#{session_user.id}"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data, [{"logo"=>UserLogo.first.img.url,"logo_thumb"=> UserLogo.first.img.url(:t1),"logo_thumb2"=> UserLogo.first.img.url(:t2),"id"=>UserLogo.first.id.to_s,"user_id"=>"502e6303421aa918ba000005"}]

    #未登录获取用户的图片列表
    login(luser.id)
    get "/user_info/photos?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data, [{"logo"=>UserLogo.first.img.url,"logo_thumb"=> UserLogo.first.img.url(:t1),"logo_thumb2"=> UserLogo.first.img.url(:t2),"id"=>UserLogo.first.id.to_s,"user_id"=>"502e6303421aa918ba000005"}]

    #上传多张图片
    post "/user_logos/create",{:user_logo => {:img => Rack::Test::UploadedFile.new('public/images/test/coupon.jpg', "image/jpeg")}}
    post "/user_logos/create",{:user_logo => {:img => Rack::Test::UploadedFile.new('public/images/test/sendpix0.jpg', "image/jpeg")}}
    assert_equal 3, luser.reload.pcount
    one,two,three = UserLogo.where({:user_id => luser.id}).sort({:_id => 1}).to_a

    #获取用户的图片列表
    get "/user_info/photos?id=#{luser.id}"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal  data, [{"logo"=>one.img.url,"logo_thumb"=>one.img.url(:t1),"logo_thumb2"=>one.img.url(:t2),"id"=>one.id.to_s,"user_id"=>"502e6303421aa918ba000005"},
      {"logo"=>two.img.url,"logo_thumb"=>two.img.url(:t1),"logo_thumb2"=>two.img.url(:t2),"id"=>two.id.to_s,"user_id"=>"502e6303421aa918ba000005"},
      {"logo"=>three.img.url,"logo_thumb"=>three.img.url(:t1),"logo_thumb2"=>three.img.url(:t2),"id"=>three.id.to_s,"user_id"=>"502e6303421aa918ba000005"}]

    #未登录改变图片位置
    logout
    get "/user_logos/change_all_position?ids=#{two.id.to_s},#{three.id.to_s},#{one.id.to_s}"
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json
    assert_equal  data, [{"logo"=>one.img.url,"logo_thumb"=>one.img.url(:t1),"logo_thumb2"=>one.img.url(:t2),"id"=>one.id.to_s,"user_id"=>"502e6303421aa918ba000005"},
      {"logo"=>two.img.url,"logo_thumb"=>two.img.url(:t1),"logo_thumb2"=>two.img.url(:t2),"id"=>two.id.to_s,"user_id"=>"502e6303421aa918ba000005"},
      {"logo"=>three.img.url,"logo_thumb"=>three.img.url(:t1),"logo_thumb2"=>three.img.url(:t2),"id"=>three.id.to_s,"user_id"=>"502e6303421aa918ba000005"}]


    #改变图片位置
    login(luser.id)
    get "/user_logos/change_all_position?ids=#{two.id.to_s},#{three.id.to_s},#{one.id.to_s}"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal  data, [{"logo"=>two.img.url,"logo_thumb"=>two.img.url(:t1),"logo_thumb2"=>two.img.url(:t2),"id"=>two.id.to_s,"user_id"=>"502e6303421aa918ba000005"},
      {"logo"=>three.img.url,"logo_thumb"=>three.img.url(:t1),"logo_thumb2"=>three.img.url(:t2),"id"=>three.id.to_s,"user_id"=>"502e6303421aa918ba000005"},
      {"logo"=>one.img.url,"logo_thumb"=>one.img.url(:t1),"logo_thumb2"=>one.img.url(:t2),"id"=>one.id.to_s,"user_id"=>"502e6303421aa918ba000005"}]

    #未登录获取用户头像
    logout
    get "/user_info/logo?id=#{luser.id}"
    assert_response :success
    assert_equal response.body, {"error"=>"not login"}.to_json

    #登录获取用户头像
    login(luser.id)
    get "/user_info/logo?id=#{luser.id}"
    assert_response :redirect
    assert_redirected_to UserLogo.find(luser.reload.head_logo_id).img.url
    
    #删除一个图片
    login(luser.id)
    get "/user_logos/delete?id=#{one.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"deleted"=> one.id.to_s}
    assert_equal luser.reload.user_logos.to_a,[two, three]
    assert_equal luser.reload.head_logo_id, two.id
    assert_equal 2, luser.reload.pcount

    #未登录删除图片
    logout
    get "/user_logos/delete?id=#{one.id}"
    assert_response :success
    assert_equal JSON.parse(response.body),{"error"=>"not login"}
    assert_equal luser.reload.user_logos.to_a,[two, three]
    assert_equal luser.reload.head_logo_id, two.id
    assert_equal 2, luser.reload.pcount

    #登录删除不属于自己的图片
    login(user1.id)
    get "/user_logos/delete?id=#{two.id}"
    assert_response :success
    assert_equal JSON.parse(response.body),{"error"=> "photo's owner 502e6303421aa918ba000005 != session user 502e6303421aa918ba00007c"}
    assert_equal luser.reload.user_logos.to_a,[two, three]
    assert_equal luser.reload.head_logo_id, two.id
    assert_equal 2, luser.reload.pcount

    #删除二个图片
    login(luser.id)
    get "/user_logos/delete?id=#{two.id}"
    assert_response :success
    assert_equal JSON.parse(response.body), {"deleted"=> two.id.to_s}
    assert_equal luser.reload.user_logos.to_a,[three]
    assert_equal luser.reload.head_logo_id, three.id
    assert_equal 1, luser.reload.pcount

    #删除最后一张图片
    get "/user_logos/delete?id=#{three.id}"
    assert_response :success
    assert_equal JSON.parse(response.body) , {"error" => "must have at least one photo"}
    assert_equal luser.reload.user_logos.to_a,[three]

  end

end

