# coding: utf-8

class GuestController < ApplicationController
  
  before_filter :guest_authorize, :except => [:login, :index]
  include Paginate

  def index
    # admin_authorize
    # redirect_to "/guest/index.htm"
  end

  def index2
    
    respond_to do |format|
      format.html { render :layout => "guest" }
    end
  end

  def welcome
    # render :layout => false
    @guest = session_guest
  end

  def channel_stat
    @guest = session_guest
    hash = {}
    sort={_id: -1}
    @user_ds_stat = paginate3("UserDsStat", params[:page], hash, sort)
  end


  def login 
    if Guest.auth(params[:id], params[:pass])
      session[:guest_id] = params[:id]
      redirect_to "/guest/index.htm"
    else
      render :action => :index
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

  private

  def guest_authorize
    if session[:guest_id].nil?
      redirect_to :action => :index, :reload => true
    end
  end

  def session_guest
    Guest.find_by_id(session[:guest_id])
  end

end
