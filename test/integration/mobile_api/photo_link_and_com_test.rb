# coding: utf-8
require 'test_helper'
require 'integration/helpers/mobile_helper'

class PhotoTest < ActionDispatch::IntegrationTest
  
  def upload_photo
    file = 'public/images/test/test.jpg'
    post "/photos/create",{:photo => {
        :img => Rack::Test::UploadedFile.new(file, "image/jpeg"),
        :room => 4928288,
        :weibo => 0,
        :desc => '一张图片'
      }
    }
  end

  def do_like(photo_id)
    post "/photos/like", :id => photo_id
  end

  def do_comment(photo_id, text)
    post "/photos/comment", :id => photo_id,:text => text
  end

  def do_dislike(photo_id)
    post "/photos/dislike", :id => photo_id
  end

  def do_recomment(photo_id, rid, text)
    post "/photos/recomment", :id => photo_id, :rid => rid, :text => text
  end

  test "聊天室上传图片，赞，评论，对评论进行回复，删除点评, 隐藏点评" do
    reload('users.js')
    reload('checkins.js')
    Photo.delete_all
    #未登录时上传图片
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"
    #登录
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]
            
    #上传图片
    upload_photo
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["id"], Photo.last.id.to_s
    assert_equal data["room"], "4928288"
    assert_equal data["weibo"], false
    assert_equal data["desc"],  '一张图片'
    assert_equal Photo.count, 1

    #退出登录
    logout
    photo = Photo.last

    #未登录赞
    do_like(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"

    #未登录评论
    do_comment(photo.id, "测试评论")
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"

    #第二个用户登录
    get "/oauth2/test_login?id=502e6303421aa918ba00007c"
    assert_equal User.find("502e6303421aa918ba00007c").id, session[:user_id]

    #赞
    do_like(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data.delete_if{|k,v| k == 't'}, {"id"=>"502e6303421aa918ba00007c", "name"=>"袁乐天"}
    assert_equal photo.like, [{"t"=> Time.now.to_s, "name"=>"袁乐天", "id"=>"502e6303421aa918ba00007c"}]

    #多次赞,能赞成功， 但数量不增加， 只是修改时间
    #因为要测试时间不同，须暂停1秒.
    sleep(1)
    do_like(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data.delete_if{|k,v| k == 't'}, {"id"=>"502e6303421aa918ba00007c", "name"=>"袁乐天"}
    assert_equal photo.like, [{"t"=> Time.now.to_s, "name"=>"袁乐天", "id"=>"502e6303421aa918ba00007c"}]

    #取消赞
    do_dislike(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data, {"ok"=> photo.id.to_s}
    assert_equal photo.like, []

    #多次取消赞
    do_dislike(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data, {"ok"=> photo.id.to_s}
    assert_equal photo.like, []

    #再次赞
    do_like(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data.delete_if{|k,v| k == 't'}, {"id"=>"502e6303421aa918ba00007c", "name"=>"袁乐天"}
    likes = [{"t"=> Time.now.to_s, "name"=>"袁乐天", "id"=>"502e6303421aa918ba00007c"}]
    assert_equal photo.like, likes

    #退出
    logout

    #未登录取消赞
    do_dislike(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"

    #第三个用户登录
    get "/oauth2/test_login?id=502e6303421aa918ba000002"
    assert_equal User.find("502e6303421aa918ba000002").id, session[:user_id]
    
    #取消赞, 不能取消别人的赞
    do_dislike(photo.id)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data, {"ok"=> photo.id.to_s}
    assert_equal photo.like, likes

    #评论图片
    do_comment(photo.id, "测试评论图片")
    assert_response :success
    data = JSON.parse(response.body)
    first_re = re = {"id"=>"502e6303421aa918ba000002","name"=>"25","txt"=>"测试评论图片", "t"=>Time.now.to_s}
    data['t'] = data['t'].to_time.localtime.to_s
    assert_equal data, re
    fcom = photo.reload.com.first
    fcom['t'] = fcom['t'].localtime.to_s
    fcom['id'] = fcom['id'].to_s
    assert_equal fcom, re

    #退出
    logout

    #未登录回复评论
    do_recomment(photo.id, "502e6303421aa918ba000002" , "测试回复评论")
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"

    #未登录删除评论
    post "/photos/delcomment", :id => photo.id, :text => "测试评论图片"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"

    #未登录对图片隐藏评论
    post "/photos/hidecomment", :id => photo.id,  :uid => '502e6303421aa918ba000002', :text => "测试评论图片"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data["error"], "not login"

    #第一个人帐号登录
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]

    #登录回复评论
    do_recomment(photo.id, "502e6303421aa918ba000002" , "测试回复评论")
    assert_response :success
    data = JSON.parse(response.body)
    re =  {"id"=>"502e6303421aa918ba000005","name"=>"袁乐天", "txt"=>"测试回复评论","t"=>Time.now.to_s,"rid"=>"502e6303421aa918ba000002", "rname"=>"25"}
    data['t'] = data['t'].to_time.localtime.to_s
    assert_equal data, re
    assert_equal photo.reload.com.count, 2
    fcom = photo.reload.com.last
    fcom['t'] = fcom['t'].localtime.to_s
    fcom['id'] = fcom['id'].to_s
    fcom['rid'] = fcom['rid'].to_s
    assert_equal fcom,re

    #删除别人的评论
    post "/photos/delcomment", :id => photo.id, :text => "测试评论图片"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data,{"ok"=> photo.id.to_s}
    assert_equal photo.reload.com.count, 2

    #删除自己的回复评论
    post "/photos/delcomment", :id => photo.id, :text => "测试回复评论"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data,{"ok"=> photo.id.to_s}
    assert_equal photo.reload.com.count, 1
    fcom = photo.reload.com.first
    fcom['t'] = fcom['t'].localtime.to_s
    fcom['id'] = fcom['id'].to_s
    assert_equal fcom, first_re

    #退出
    logout

    #第三人登录
    get "/oauth2/test_login?id=502e6303421aa918ba000002"
    assert_equal User.find("502e6303421aa918ba000002").id, session[:user_id]

    #删除评论
    post "/photos/delcomment", :id => photo.id, :text => "测试评论图片"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data, {"ok"=> photo.id.to_s}
    assert_equal photo.reload.com, []

    #评论图片
    do_comment(photo.id, "测试评论图片")
    assert_response :success
    data = JSON.parse(response.body)
    second_re = re = {"id"=>"502e6303421aa918ba000002","name"=>"25","txt"=>"测试评论图片", "t"=>Time.now.to_s}
    data['t'] = data['t'].to_time.localtime.to_s
    assert_equal data, re
    fcom = photo.reload.com.first
    fcom['t'] = fcom['t'].localtime.to_s
    fcom['id'] = fcom['id'].to_s
    assert_equal fcom, re
    assert_equal photo.reload.com.count, 1

    #退出
    logout

    #第一个人帐号登录
    get "/oauth2/test_login?id=502e6303421aa918ba000005"
    assert_equal User.find("502e6303421aa918ba000005").id, session[:user_id]
    
    #登录对图片隐藏评论
    post "/photos/hidecomment", :id => photo.id,  :uid => '502e6303421aa918ba000002', :text => "测试评论图片"
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal data, {"ok"=> photo.id.to_s}
    assert_equal photo.reload.com.count, 1
    fcom = photo.reload.com.first
    fcom['t'] = fcom['t'].localtime.to_s
    fcom['id'] = fcom['id'].to_s
    assert_equal fcom, second_re.merge("hide" => true)


  end

end