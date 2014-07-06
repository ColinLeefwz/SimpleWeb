# coding: utf-8
class  ActiveSupport::TestCase
  def logout
    get '/oauth2/logout'
    raise("注销失败") if  session[:user_id] != nil
  end

  def login(user_id)
    get "/oauth2/test_login?id=#{user_id}"
    raise("登录失败！") if User.find(user_id).id != session[:user_id]
  end

end