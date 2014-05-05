# coding: utf-8

class UserInfoController < ApplicationController
  include PhoneUtil
  
  before_filter :user_login_filter, :except => [:photos, :logo ]
  before_filter :user_is_session_user, :only => [:get_comment_names, :privacy]
  
  #deprecate
  def get
    #Xmpp.error_notify("deprecated: user_info/get") if UserDevice.user_ver_redis(params[:id]).to_f>=2.3
    render :json => user_info_cache(params[:id],session[:user_id])
  end

  def basic
    user = User.find_by_id(params[:id])
    render :json => user.safe_output.to_json
  end
    
  def last_loc
    user = User.find_by_id(params[:id])
    hash = {id:params[:id]}.merge(user.last_location(session[:user_id]))
    render :json => hash.to_json    
  end
  
  def relation
    user = User.find_by_id(params[:id])
    hash = {id:params[:id]}.merge(user.relation_hash(session[:user_id]))
    render :json => hash.to_json   
  end
  
  def lords
    user = User.find_by_id(params[:id])
    shops = user.lords[0,10].map{|id| Shop.find_by_id(id)}
    if user.ver.to_f >= 3
      if $redis.zadd("VISIT#{user.id}", Time.now.to_i, session[:user_id])
        Xmpp.send_normal(session[:user_id], user.id,"#{session_user.name}访问了你的主页噢~", "VISIT#{session[:user_id]},#{user.id}")
      end
    end
    render :json => shops.select{|x| x!=nil}.map{|x| x.safe_output_with_users}.to_json    
  end
  
  def search
    if is_phone?(params[:name])
      user = User.where({phone:params[:name]}).first
    end
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    users = User.where({ name: /#{params[:name]}/i}).skip((page-1)*pcount).limit(pcount)
    users = [user] + users if user
    ret = users.map do |u| 
      hash = u.safe_output.merge(u.relation_hash(session[:user_id]))
      hash.merge!({wb_name:u.wb_name, qq_name:u.qq_name})
      hash.merge!({distance: u.distance(session[:user_id])})
      hash.merge!({black:1}) if session_user.black?(u.id)
      hash
    end
    ret.sort {|a,b| b["distance"]<=>a["distance"]}
    render :json => ret.to_json    
  end
  
  #deprecate
  def logo
    #Xmpp.error_notify("deprecated: user_info/logo") if UserDevice.user_ver_redis(params[:id]).to_f>=2.3
    begin
      if session[:user_id].to_s == params[:id]
        user = User.find_primary(params[:id])
      else
        user = User.find_by_id(params[:id])
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
    cins = Checkin.merge_same_location_half_day(checkins).map {|x| x.to_trace(params[:ver])}
    if params[:hash]
      ret = {:pcount => checkins.size}
      ret.merge!( {:data => cins})
    else
      ret = [{:pcount => checkins.size}]
      ret << {:data => cins}
    end
    render :json => ret.to_json
  end

  def other_trace
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 5 if pcount==0
    #TODO: 根据隐私控制能看多少条
    checkins = User.find_by_id(params[:other_id]).checkins.skip((page-1)*pcount).limit(pcount)
    cins = checkins.map {|x| x.to_trace(params[:ver])}
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
    hash = session_user_no_cache.output_self
    wbexpire = $redis.get("wbexpire#{session[:user_id]}").to_i
    if wbexpire > Time.now.to_i
      wbtoken = $redis.get("wbtoken#{session[:user_id]}")
      hash.merge!(wbtoken:wbtoken, wbexpire:wbexpire) if wbtoken
    end
    qqexpire = $redis.get("qqexpire#{session[:user_id]}").to_i
    if qqexpire > Time.now.to_i
      qqtoken = $redis.get("qqtoken#{session[:user_id]}")
      hash.merge!(qqtoken:qqtoken, qqexpire:qqexpire) if qqtoken
    end
    if session_user.is_kx_or_co?
      hash.merge!({"kx"=>1})
    end
    render :json => hash.to_json
  end

  def set
    if !request.post?
      render :json => {:error => "only support post request"}.to_json
    else
      user = session_user_no_cache
      hash = {}
      hash[:name] = params[:name].strip[0,10] unless (params[:name].nil? || params[:name].index("脸脸") )
      hash[:gender] = params[:gender].to_i unless params[:gender].nil?
      hash[:birthday] = params[:birthday]  unless params[:birthday].nil?
      hash[:invisible] = params[:invisible]  unless params[:invisible].nil?
      hash[:signature] = params[:signature]  unless params[:signature].nil?
      hash[:job] = params[:job]  unless params[:job].nil?
      hash[:jobtype] = params[:jobtype]  unless params[:jobtype].nil?
      hash[:hobby] = params[:hobby]  unless params[:hobby].nil?
      hash[:wb_hidden] = params[:wb_hidden].to_i  unless params[:wb_hidden].nil?
      hash[:no_push] = (params[:no_push]=="1")  unless params[:no_push].nil?
      if user.update_attributes! hash
        Rails.cache.delete "UI#{user.id}"    
        render :json => user.output_self.to_json
      else
        render :json => {:error => "update user info failed"}.to_json
      end
    end
  end
  
  def privacy
    user = session_user_no_cache
    hash = {}
    hash[:pvc1] = params[:pvc1].to_i  unless params[:pvc1].nil?
    hash[:pvc2] = (params[:pvc2]=="1")  unless params[:pvc2].nil?
    hash[:pvc3] = params[:pvc3].to_i  unless params[:pvc3].nil?
    hash[:pvc4] = params[:pvc4].to_i  unless params[:pvc4].nil?    
    if user.update_attributes! hash
      Rails.cache.delete "UI#{user.id}"    
      render :json => {"success" => 1}.to_json
    else
      render :json => {:error => "update user info failed"}.to_json
    end
  end
  
  def set_comment_name
    CommentName.save_name(session[:user_id], params[:id], params[:name])
    render :json => {"success" => 1}.to_json
  end
  
  def get_comment_names
    cn = CommentName.find_by_id(session[:user_id])
    if cn
      render :json => cn.v.to_json
    else
      render :json => [].to_json
    end
  end
  
  private
  def user_info_cache(uid,vid)
    Rails.cache.fetch("UI#{uid}#{vid}", :expires_in => 12.hours) do
      User.find_by_id(uid).output_with_relation(vid).to_json
    end
  end
    
end
