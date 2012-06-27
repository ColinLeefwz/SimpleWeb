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
    render :json => user_logo.output_hash.to_json
  end
  
  def position
    user_logo = UserLogo.find(params[:id])
    if user_logo.user_id != session[:user_id]
      render :json => {:error => "photo's owner #{user_logo.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    user_logo.change_ord(params[:order].to_i)
    render :json => user_logo.output_hash.to_json
  end


  def delete
    user_logo = UserLogo.find(params[:id])
    if user_logo.user_id != session[:user_id]
      render :json => {:error => "photo's owner #{user_logo.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    if user_logo.destroy
      render :json => {:deleted => params[:id]}.to_json
    else
      render :json => {:error => "user_logo #{params[:id]} delete failed"}.to_json
    end
  end

  private
  def user_authorize
    if session_user.nil?
      render :json => {:error => "not login"}
    end
  end
end