# coding: utf-8

class UserInfoController < ApplicationController
  
  before_filter :user_login_filter, :except => [:photos, :logo ]
  
  def get
    user = User.find_by_id(params[:id])
    if params[:id]==$xpuid
      user = User.fake_user(session_user)
    end
    render :json => user.output_with_relation(session[:user_id]).to_json
  end
  
  def logo
    begin
      user = User.find_by_id(params[:id])
      if params[:id]==$xpuid
        user = User.fake_user(session_user)
      end
      if params[:size].to_i==0
        redirect_to UserLogo.img_url(user.head_logo_id)
      elsif params[:size].to_i==2
        redirect_to UserLogo.img_url(user.head_logo_id,:t2)
      else
        redirect_to UserLogo.img_url(user.head_logo_id,:t1)
      end
    rescue Exception => e
      render :json => {error:"User #{params[:id]}'s Head Logo not exists."}.to_json
    end
  end
  
  #个人头像列表
  def photos
    uid = params[:id]
    if params[:id]==$xpuid
      user = User.fake_user(session_user)
      uid = user.id
    end
    ids = UserLogo.ids_cache(uid)
    arr = ids.map do |id|
      {:logo => UserLogo.img_url(id), 
        :logo_thumb => UserLogo.img_url(id,:t1), 
        :logo_thumb2 => UserLogo.img_url(id,:t2),
        id: id, user_id:uid}
    end
    render :json => arr.to_json
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
    user = session_user_no_cache
    render :json => user.attr_with_id.merge!(user.head_logo_hash).to_json
  end

  def set
    if !request.post?
      render :json => {:error => "only support post request"}.to_json
    else
      user = session_user_no_cache
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
