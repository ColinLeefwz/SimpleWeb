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
    user.set(:head_logo_id, user_logo.id) unless user.pcount>0
    user.inc(:pcount, 1)
    expire_cache
    render :json => user_logo.output_hash.to_json
  end
  
  def replace
    # TODO: 图片替换
  end
  
  def change_all_position
    ids = params[:ids].split(",")
    ids.each_with_index do |id,index|
      user_logo = UserLogo.find(id)
      user_logo.user.set(:head_logo_id, user_logo.id) if index==0
      raise "photo#{id}'s owner #{user_logo.user_id} != session user #{session[:user_id]}" if user_logo.user_id != session[:user_id]
      user_logo.update_attribute("ord",1+index*10)
    end
    expire_cache
    render :json => session_user.user_logos.map{|x| x.output_hash}.to_json
  end


  def delete
    begin
      user_logo = UserLogo.find(params[:id])
    rescue
      error_log "\nTry to delete non-exist logo:#{params[:id]}, #{Time.now}"
      render :json => {:deleted => params[:id]}.to_json
      return
    end

    if user_logo.user_id != session[:user_id]
      render :json => {:error => "photo's owner #{user_logo.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    user = user_logo.user
    if user.pcount<=1
      render :json => {:error => "must have at least one photo"}.to_json
      return
    end
    change_head_logo = (user.head_logo_id==user_logo.id)
    if user_logo.destroy
      user.inc(:pcount, -1)
      user.set(:head_logo_id, user.user_logos[0].id)  if change_head_logo
      expire_cache
      render :json => {:deleted => params[:id]}.to_json
    else
      render :json => {:error => "user_logo #{params[:id]} delete failed"}.to_json
    end
  end
  
  def show
    photo = UserLogo.find(params[:id])
    if params[:size].to_i==0
      redirect_to photo.img.url
    elsif params[:size].to_i==2
      redirect_to photo.img.url(:t2)
    else
      redirect_to photo.img.url(:t1)
    end
  end
  
  private 
  def expire_cache
    expire_fragment "views/UIP#{session[:user_id]}.json"
  end

  
end