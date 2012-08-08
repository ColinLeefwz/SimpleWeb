class UserInfoController < ApplicationController
  def get
    if session_user.nil?
      render :json => {:error => "not login"}.to_json
    else
      user = User.find_by_id params[:id]
      if user.nil?
        render :json => {:error => "user #{params[:id]} not found"}.to_json
      else
        render :json => user.output_with_relation(session[:user_id]).to_json
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
        if params[:size].to_i==0
          response.headers['IMG_URL'] = user.head_logo.avatar.url
          send_file user.head_logo.avatar.path
        elsif params[:size].to_i==2
          response.headers['IMG_URL'] = user.head_logo.avatar.url(:thumb2)
          send_file user.head_logo.avatar.path(:thumb2)
        else
          response.headers['IMG_URL'] = user.head_logo.avatar.url(:thumb)
          send_file user.head_logo.avatar.path(:thumb)
        end
      end
    end
  end
  
  def photos
    user = User.find_by_id params[:id]
    if user.nil?
      render :json => {:error => "user #{params[:id]} not found"}.to_json
    else
      render :json => user.user_logos.map{|x| x.output_hash}.to_json
    end
  end
  
  def get_self
    user = session_user
    if user.nil?
      render :json => {:error => "not login"}.to_json
    else
      render :json => user.attributes.merge(user.head_logo_hash).to_json
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
      hash[:signature] = params[:signature]  unless params[:signature].nil?
      hash[:job] = params[:job]  unless params[:job].nil?
      hash[:jobtype] = params[:jobtype]  unless params[:jobtype].nil?
      hash[:hobby] = params[:hobby]  unless params[:hobby].nil?
      if user.update_attributes hash
        render :json => user.attributes.to_json
      else
        render :json => {:error => "update user info failed"}.to_json
      end
    end
  end
  
end
