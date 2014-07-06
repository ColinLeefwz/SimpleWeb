# coding: utf-8

class GuestController < ApplicationController
  
  before_filter :guest_authorize, :except => [:login, :index]
  include Paginate

  def index2  
    render :layout => "guest"
  end

  def welcome
    @guest = session_guest
    # render :layout => false
  end

  def channel_stat
    @guest = session_guest
    hash = {}
    sort={_id: -1}
    @user_ds_stat = paginate3("UserDsStat", params[:page], hash, sort)
  end


  def login 
    if (guest = Guest.auth(params[:name], params[:pass]))
      session[:guest_id] = guest.id
      redirect_to "/guest/index.htm"
    else
      render :action => :index
    end
  end

  def chpass
     if request.post?
      return flash.now[:notice] = '原始密码错误' if params[:opass] != session_guest.password
      return flash.now[:notice] = '密码不能少于4位' if params[:npass].to_s.length < 4
      session_guest.set(:password, params[:npass])
      return render :index2
     end
  end
  
  def logout
    reset_session
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
