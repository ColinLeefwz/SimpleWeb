class UserInfoController < ApplicationController
  
  before_filter :user_login_filter
  
  def get
    user = User.find(params[:id])
    render :json => user.output_with_relation(session[:user_id]).to_json
  end
  
  def logo
    user = User.find(params[:id])
    if params[:size].to_i==0
      response.headers['IMG_URL'] = user.head_logo.img.url
      redirect_to user.head_logo.img.url
    elsif params[:size].to_i==2
      response.headers['IMG_URL'] = user.head_logo.img.url(:t2)
      redirect_to user.head_logo.img.url(:t2)
    else
      response.headers['IMG_URL'] = user.head_logo.img.url(:t1)
      redirect_to user.head_logo.img.url(:t1)
    end
  end
  
  def photos
    user = User.find(params[:id])
    render :json => user.user_logos.map{|x| x.output_hash}.to_json
  end
  
  def get_self
    user = session_user
    render :json => user.attr_with_id.merge(user.head_logo_hash).to_json
  end

  def set
    if !request.post?
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
      if user.update_attributes! hash
        render :json => user.attributes.to_json
      else
        render :json => {:error => "update user info failed"}.to_json
      end
    end
  end
  
end
