# coding: utf-8

class UserInfoController < ApplicationController
  
  before_filter :user_login_filter
  
  def get
    user = User.find(params[:id])
    render :json => user.output_with_relation(session[:user_id]).to_json
  end
  
  def logo
    user = User.find(params[:id])
    if params[:size].to_i==0
      redirect_to user.head_logo.img.url
    elsif params[:size].to_i==2
      redirect_to user.head_logo.img.url(:t2)
    else
      redirect_to user.head_logo.img.url(:t1)
    end
  end
  
  def photos
    render :json => UserLogo.logos(params[:id]).map{|x| x.output_hash}.to_json
  end
  
  def trace
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    checkins = session_user.checkins.skip((page-1)*pcount).limit(pcount)
    cins = Checkin.merge_same_location_half_day(checkins).map {|x| x.to_trace}
    if params[:hash]
      ret = {:pcount => checkins.size}
      ret.merge!( {:data => cins})
    else
      ret = [{:pcount => checkins.size}]
      ret << {:data => cins}
    end
    render :json => ret.to_json
  end
  
  def get_self
    user = session_user
    data = {}
    wbtoken = $redis.get("wbtoken#{session_user.id}")
    data.merge!({wb_token: wbtoken , wb_expire: $redis.get("wbexpire#{session_user.id}") }) if wbtoken
    qqtoken =  $redis.get("qqtoken#{session_user.id}")
    data.merge!({qq_token:  qqtoken, qq_expire: $redis.get("qqexpire#{session_user.id}") }) if qqtoken    
    render :json => user.attr_with_id.merge!(user.head_logo_hash).merge!(data).to_json
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
