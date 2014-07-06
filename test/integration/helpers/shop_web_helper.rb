# coding: utf-8
class  ActiveSupport::TestCase
  def slogout
    get "/shop_login/logout"
  end

  def slogin(sid)
    shop = Shop.find(sid)
    post "/shop_login/login",{:id => shop.id, :password => '123456'}
  end

end