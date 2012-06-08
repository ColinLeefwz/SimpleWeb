class UserLogosController < ApplicationController
  before_filter :user_authorize, :except => [:update]
  layout "user"

  def index
    @user_logo = UserLogo.find_by_user_id(session_user.id, :order => "id desc")
    @user_logo = UserLogo.new unless @user_logo
  end

  def new
    @user_logo=UserLogo.find_by_user_id(session_user.id, :order => "id desc")
    if @user_logo.nil?
      @new=1
    else
      @new=0
    end
    @user_logo = UserLogo.new if @user_logo.nil?
  end

  def create
    @user_logo = UserLogo.new(params[:user_logo])
    @user_logo.user_id=session[:user_id]
    if @user_logo.save
      user = @user_logo.user
      render :json => {:id => user.id,:wb_uid => user.wb_uid, :photo_url => @user_logo.avatar.url }
    else
      render :json => {:error => "photo upload failed"}
    end
  end


  private
  def user_authorize
    if session_user.nil?
      render :json => {:error => "not login"}
    end
  end
end