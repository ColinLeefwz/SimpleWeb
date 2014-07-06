# coding: utf-8

class AdminLoginController < ApplicationController

=begin
  if ENV["RAILS_ENV"] == "production"
      ssl_required :login, :index, :logout
  end
=end
  
  # ssl_required :index, :login, :logout
  before_filter :admin_authorize, :except => [:login, :logout]
  

  def index
    admin_authorize
    redirect_to "/admin/index.htm"
  end


  def index2
    admin_authorize
    respond_to do |format|
      format.html { render :layout => "admin" }
    end
  end

  def welcome
    admin_authorize
    render :layout => false
  end

  
  def login
    session[:admin_id] = nil
    if request.post?
      #	  保存用户登录信息 2010-05-07 13:38:00 修改
#      admin_login_log = AdminLoginLog.new
#      admin_login_log.login_time = Time.zone.now
#      admin_login_log.ip = request.remote_ip
#      admin_login_log.name = params[:name]
#      admin_login_log.password = params[:password]
      admin = Admin.auth(params[:name], params[:password])
      if admin
        # 用户的登录名/手机号是可以修改的，所以保存 admin_id
#        admin_login_log.admin_id = admin.id
#        admin_login_log.login_suc = true
#        admin_login_log.save
        
        session[:admin_id] = admin.id
        uri = session[:o_uri]
        session[:o_uri] = nil
        redirect_to( uri || {:action => "index"} )
      else
#        admin_login_log.save
        flash.now[:notice] = "用户名或者密码错误！"
      end
    end
  end

  def logout
    # 1 在浏览器未关闭的前提下，第一个用户a退出后，第二个用户b（也可以是a）再使用同一个浏览器登录后，用户a和用户b的session_id是相同的。
    # 2 第一个用户a退出后，关闭浏览器，第二个用户b（也可以是a）重新打开用户a使用的同一个浏览器登录后，用户a和用户b的session_id是相同的。
    # 3 以上测试在IE7.0 和 Firefox 3.6 中表现相同。
    # 4 用户退出时要清空这个session中的admin_id，这个session的保留不再有意义，故清空这个session
    reset_session
    # session[:admin_id] = nil
    flash[:notice] = "退出系统！"
    redirect_to( :action => "login" )
  end

end
