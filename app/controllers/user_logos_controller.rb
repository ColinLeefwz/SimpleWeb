class UserLogosController < ApplicationController
  before_filter :user_authorize

  def index
    @user_logo = UserLogo.find_by_user_id(session_user.id, :order => "id desc")
    @user_logo = UserLogo.new unless @user_logo
  end

  def create
    user_logo = UserLogo.new(params[:user_logo])
    user_logo.user_id = session[:user_id]
    user_logo.save!
    render :json => user_logo.user.safe_output
  end


  private
  def user_authorize
    if session_user.nil?
      render :json => {:error => "not login"}
    end
  end
end