class UserLogosController < ApplicationController
  before_filter :user_login_filter

  def index
    render :json => session_user.user_logos.to_json
  end

  def create
    user_logo = UserLogo.new(params[:user_logo])
    user_logo.user_id = session[:user_id]
    user_logo.save!
    user = user_logo.user
    unless user.multip
      user.set_if_multip
    end
    render :json => user_logo.output_hash.to_json
  end
  
  def replace
    # TODO: 图片替换
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
  
  def change_all_position
    ids = params[:ids].split(",")
    ids.each_with_index do |id,index|
      user_logo = UserLogo.find(id)
      raise "photo#{id}'s owner #{user_logo.user_id} != session user #{session[:user_id]}" if user_logo.user_id != session[:user_id]
      user_logo.update_attribute("ord",1+index*10)
    end
    render :json => session_user.user_logos.map{|x| x.output_hash}.to_json
  end


  def delete
    user_logo = UserLogo.find(params[:id])
    if user_logo.user_id != session[:user_id]
      render :json => {:error => "photo's owner #{user_logo.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    user = user_logo.user
    countp = user.user_logos.count()
    if countp<=1
      render :json => {:error => "must have at least one photo"}.to_json
      return
    end
    if user_logo.destroy
      user.update_attributes!({multip:false}) if countp<=2
      render :json => {:deleted => params[:id]}.to_json
    else
      render :json => {:error => "user_logo #{params[:id]} delete failed"}.to_json
    end
  end

end