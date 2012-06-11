class UserInfoController < ApplicationController
  def get
    if session_user.nil?
      render :json => {:error => "not login"}.to_json
    else
      user = User.find_by_id params[:id]
      if user.nil?
        render :json => {:error => "user #{params[:id]} not found"}.to_json
      else
        render :json => user.safe_output.to_json
      end
    end
  end
  
  def logo
    if session_user.nil?
      render :json => {:error => "not login"}.to_json
    else
      user = User.find_by_id params[:id]
      if user.nil?
        render :json => {:error => "user #{params[:id]} not found"}.to_json
      else
        redirect_to user.latest_logo.avatar.url
      end
    end
  end
  
  def get_self
    user = session_user
    if user.nil?
      render :json => {:error => "not login"}.to_json
    else
      render :json => user.attributes.merge(user.latest_logo_hash).to_json
    end
  end

  def set
    if session_user.nil?
      render :json => {:error => "not login"}.to_json
    elsif !request.post?
      render :json => {:error => "only support post request"}.to_json
    else
      user = session_user
      hash = {}
      hash[:name] = params[:name] unless params[:name].nil?
      hash[:gender] = params[:gender] unless params[:gender].nil?
      hash[:birthday] = params[:birthday]  unless params[:birthday].nil?
      hash[:invisible] = params[:invisible]  unless params[:invisible].nil?
      if user.update_attributes hash
        render :json => user.attributes.to_json
      else
        render :json => {:error => "update user info failed"}.to_json
      end
    end
  end
  
end
