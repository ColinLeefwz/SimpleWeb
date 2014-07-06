# coding: utf-8

module LoginHelper

  def session_admin_name
    Admin.find(session[:admin_id]).name
  end

  def session_shop_name
    Shop.find(session[:shop_id]).name
  end
  
  def session_user_name
    # 模糊处理手机用户名
    User.find(session[:user_id]).show_name
  end

  def session_user
    #TODO: 为什么在application.rb中定义了这个方法，在view中却无法访问？
    User.find(session[:user_id])
  end

  def session_shop
    Shop.find(session[:shop_id])
  end

  def session_admin
    Admin.find(session[:admin_id])
  end
  
  def session_shop?
    if session[:shop_id]
      true
    else
      false
    end
  end

  def session_admin?
    if session[:admin_id]
      true
    else
      false
    end
  end

  def home_url
    if session[:user_id]
      '/user_login'
    elsif session[:shop_id]
      '/shop_login'
    elsif session[:admin_id]
      '/admin_login'
    else
      nil
    end
  end

  def logout_url(redirect_url = nil)
    if session[:user_id]
      '/user_login/logout?redirect_url=' + redirect_url.to_s
    elsif session[:shop_id]
      '/shop_login/logout?redirect_url=' + redirect_url.to_s
    elsif session[:admin_id]
      '/admin_login/logout?redirect_url=' + redirect_url.to_s
    else
      nil
    end
  end

  def home_name
    if session[:user_id]
      '我的一渡'
    elsif session[:shop_id]
      '商家管理后台'
    elsif session[:admin_id]
      '管理员后台'
    else
      nil
    end
  end

  def session_login_name
    if session[:user_id]
      session_user_name
    elsif session[:shop_id]
      session_shop_name
    elsif session[:admin_id]
      session_admin_name
    else
      nil
    end
  end

#  def latest_login_time(account, id)
#    login_logs = []
#    if account == "admin" && id > 0
##      login_logs = AdminLoginLog.find_by_sql(["select login_time from admin_login_logs where admin_id = ? and login_time < ? and login_suc = 1 order by login_time desc limit 1", id, Time.zone.now])
#    elsif account == "shop" && id > 0
#      login_logs = ShopLoginLog.find_by_sql(["select login_time from shop_login_logs where shop_id = ? and login_time < ? and login_suc = 1 order by login_time desc limit 1, 1", id, Time.zone.now])
#    elsif account == "user" && id > 0
#      login_logs = UserLoginLog.find_by_sql(["select login_time from user_login_logs where user_id = ? and login_time < ? and login_suc = 1 order by login_time desc limit 1, 1", id, Time.zone.now])
#    end
#    return login_logs[0].login_time if (login_logs && login_logs.length >= 1)
#  end

end
